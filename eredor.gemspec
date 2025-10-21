# frozen_string_literal: true

require_relative "lib/eredor/version"

Gem::Specification.new do |spec|
  spec.name = "eredor"
  spec.version = Eredor::VERSION
  spec.authors = ["Guilherme Ribeiro"]
  spec.email = ["devguilhermeribeiro000@proton.me"]

  spec.summary = "Minimal classes for small web applications"
  spec.description = "Eredor is a minimal set of OOP-based classes to help you develop small web applications without a dedicated framework. No magic, just Ruby."
  spec.homepage = "https://github.com/devguilhermeribeiiro/eredor"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.2.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/devguilhermeribeiiro/eredor"
  spec.metadata["changelog_uri"] = "https://github.com/devguilhermeribeiiro/eredor/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ Gemfile .gitignore .rubocop.yml])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
