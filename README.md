# 🏔️ **Eredor**


[![Gem Version](https://badge.fury.io/rb/eredor.svg)](https://rubygems.org/gems/eredor)
[![Downloads](https://badgen.net/rubygems/dt/eredor)](https://rubygems.org/gems/eredor)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](https://opensource.org/licenses/MIT)
[![GitHub Repo stars](https://img.shields.io/github/stars/devguilhermeribeiiro/eredor?style=social)](https://github.com/devguilhermeribeiiro/eredor)

> Eredor is a minimal set of OOP-based classes to help you develop small web applications without a dedicated framework. No magic, just Ruby.   

---
## ⚡ **Instalation**

Install via [RubyGems.org](https://rubygems.org/gems/eredor):

```bash
gem install eredor
```
Or add to your Gemfile:

```bash
bundle add eredor
bundle install
```

## Usage

Add to your config.ru:

```bash
require 'rack'
require 'eredor'

run do |env|
  request = Rack::Request.new(env)
  router = Eredor::Router.new(request)

  router.get '/' do
    '<h1>Hello from Eredor</h1>'
  end

  router.handle
end
```
Ensure you have the rackup gem installed and run:
```bash
rackup
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/devguilhermeribeiiro/eredor. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/devguilhermeribeiiro/eredor/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Eredor project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/devguilhermeribeiiro/eredor/blob/master/CODE_OF_CONDUCT.md).
