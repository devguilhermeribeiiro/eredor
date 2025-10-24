# frozen_string_literal: false

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
      params = @request.params

      @routes[method].each do |route|
        if route[:pattern]
          match = route[:pattern].match(path)
          next unless match

          params.merge!(extract_params(match))
          return call_handler(route, params)
        elsif route[:path] == path
          return call_handler(route, params)
        end
      end

      not_found
    end

    private

    def register_route(method, path, &block)
      raise(StandardError, "A block must be given") unless block_given?

      regex_path = path.gsub(/:(\w+)/) { |m| "(?<#{m[1..-1]}>[^/]+)" }
      pattern = /\A#{regex_path}\z/

      @routes[method] << {
        path: path,
        pattern: path.include?(":") ? pattern : nil,
        handler: block
      }
    end

    def extract_params(match)
      match.named_captures.transform_keys(&:to_sym)
    end

    def call_handler(route, params)
      result = route[:handler].call(params)

      case result
      when Array || Rack::Response then result # já está no formato [status, headers, body]
      when String then [200, { "content-type" => "text/html" }, [result]]
      else
        [500, { "content-type" => "text/plain" }, ["Internal Server Error"]]
      end
    end

    def not_found
      [404, { "content-type" => "text/plain" }, ["Not Found"]]
    end
  end

  class BaseController
    attr_reader :params

    def initialize(params)
      @params = params
    end

    def render(file)
      content = get_view(file)
      template = ERB.new(content)
      template.result(binding)
    end

    private

    def get_view(file)
      File.read("./app/views/#{controller_name}/#{file}.html.erb")
    end

    def controller_name
      controller = self.class.name.to_s
      controller.gsub(/Controller/, "").downcase
    end
  end
end
