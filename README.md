# Api::Tester
[![Build Status](https://travis-ci.org/araneforseti/api-tester.svg?branch=master)](https://travis-ci.org/araneforseti/api-tester)

Work in Progress!

This gem is intended to enable easy creation of tests for RESTful API services when given a contract.

Intended Features:
- Boundary Testing (positive and negative cases)
    - Consistency testing of error messages within boundary tests
- "Standard" Negative case testing
    - eg, 404s of path urls
    - Query parameter handling
- Documentation testing
    - Define the request and response. If tests are true, generates documentation

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'api-tester'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install api-tester

## Usage

TODO

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/api-tester.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

