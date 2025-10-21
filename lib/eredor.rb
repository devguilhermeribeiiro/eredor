# frozen_string_literal: true

require_relative "eredor/version"

module Eredor
  class Error < StandardError; end

  class Router
    attr_reader :request
    attr_accessor :routes

    HTTP_METHODS = %i[GET POST PUT PATCH DELETE].freeze

    def initialize(request)
      @request = request
      @routes = Hash.new { |h, k| h[k] = [] }
    end

    # define métodos http dinâmicamente. Ex: get/post/put...
    HTTP_METHODS.each do |method|
      define_method(method.downcase) do |path, &block|
        register_route(method, path, &block)
      end
    end

    def handle
      method = @request.request_method.to_sym
      path   = @request.path
      body   = %w[POST PUT PATCH].include?(method.to_s) ? @request.POST : nil
      query  = @request.GET

      @routes[method].each do |route|
        if route[:pattern]
          match = route[:pattern].match(path)
          next unless match

          params = extract_params(match, route[:keys])
          return call_handler(route, params, body, query)
        elsif route[:path] == path
          return call_handler(route, {}, body, query)
        end
      end

      not_found
    end

    private

    def register_route(method, path, &block)
      raise(StandardError, 'A block must be given') unless block_given?

      keys = []
      regex_path = path.gsub(/:(\w+)/) do |match|
        keys << match[1..-1].to_sym
        "(?<#{keys.last}>[^/]+)"
      end

      route = { path: path, handler: block }
      route[:pattern] = /\A#{regex_path}\z/ if keys.any?
      route[:keys] = keys if keys.any?

      @routes[method] << route
    end

    def extract_params(match, keys)
      keys.each_with_object({}) do |key, h|
        h[key] = match[key.to_s]
      end
    end

    def call_handler(route, params, body, query)
      env = {
        params: params,
        body: body,
        query: query
      }
      result = route[:handler].call(env)

      # Permitir retorno flexível
      case result
      when Array || Rack::Response then result # já está no formato [status, headers, body]
      when String then [200, { 'content-type' => 'text/html' }, [result]]
      else
        [500, { 'content-type' => 'text/plain' }, ['Internal Server Error']]
      end
    end

    def not_found
      [404, { 'content-type' => 'text/plain' }, ['Not Found']]
    end
  end
end
