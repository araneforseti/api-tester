# Api::Tester

[![Gem Version](https://badge.fury.io/rb/api-tester.svg)](https://badge.fury.io/rb/api-tester)
[![Build Status](https://github.com/araneforseti/api-tester/workflows/Test/badge.svg)](https://github.com/araneforseti/api-tester/actions?query=workflow%3ATest+branch%3Amaster)

Work in Progress! Use at own risk, definitely not ready
for prime time! To isolate your project from the changes, be sure to specify which gem version you use.

This gem is intended to enable easy creation of tests for
RESTful API services when given a contract.

When using, be sure to follow the documentation for the version of the gem you use. The documentation below
relates to the unpublished gem version actively under development

Check out [API Tester Example](https://github.com/araneforseti/example_api-tester) for an example in action

## Out of Project Scope

- Logic testing (eg, if X is between A and B, then Y is required)

## Usage

### Installation

Add this line to your application's Gemfile (Note: specify your version due to gem's currently volatile nature):

```ruby
gem 'api-tester', '1.1.3' 
```

And then execute:

    bundle

Or install it yourself as:

    gem install api-tester

### Usage in Code

Warning: This gem is still in alpha stage. Use at own risk
understanding the contract will change until the first
stable release

Define your contract and endpoints using

```ruby
require 'api-tester/definition/contract'
require 'api-tester/definition/endpoint'
contract = ApiTester::Contract.new "API Name", "http://yourbase.com/api"
endpoint = ApiTester::Endpoint.new "Some name which is currently unused", "/endpoint"
```

Define methods on endpoints

```ruby
endpoint.add_method ApiTester::SupportedVerbs::GET, expected_response, expected_request
```

Note: While an extensive list of verbs exists in ApiTester::SupportedVerbs, you can define your own (with the caveat they have to be supported by RestClient)

Define fields used by the method (both Request and Response)

```ruby
expected_request = Request.new.add_field(ApiTester::Field.new "fieldName")
```

Note: Similar to methods, you can create your own fields.
They need to respond to:

```ruby
field.has_subfields?
values_array = field.negative_boundary_values # list of inputs which the field does not support
field.good_cases # list of potential good inputs for call variations
```

Define which modules you want to use through a config

```ruby
config = ApiTester::Config().with_module(Format)
```

Put them together and call go and off you go!

```ruby
request = ApiTester::Request.new.add_field(ApiTester::Field.new "fieldName")
expected_response = ApiTester::Response.new(200).add_field(ApiTester::Field.new "fieldName")
endpoint = ApiTester::Endpoint.new "Unused Name", "/endpoint"
endpoint.add_method ApiTester::SupportedVerbs::GET, expected_response, request
contract = Contract.new "API Name", "http://yourbase.com/api"
contract.add_endpoint endpoint
config = ApiTester::Config().with_module(Format)
expect(ApiTester.go(contract, config)).to be true

```

### Dependencies

If any of your API endpoints have some setup which needs to happen before or after each call (eg, path param represents resource which needs to be created), you can use the TestHelper interface:

```ruby
class InfoCreator < ApiTester::TestHelper
  def before
    puts "This code runs before every call"
  end

  def retrieve_param key
     puts "If any created data needs to be accessed (eg, a path param), allow it to be retrieved here"
  end

  def after
    puts "This code runs after every call"
  end
end

endpoint = ApiTester::Endpoint.new "Endpoint Name", "www.endpoint-url.com"
endpoint.test_helper = InfoCreator.new
expect(tester.go).to be true
```  

## Modules

### Boundary

This module will test out various edge cases and
ensure error handling is consistent

### Good Case

This module ensures your 'default request' works
appropriately

### Good Variations

This module tries a variety of requests using the
good case from fields, and compares them to the expected
format of successful responses.

### Format

This module makes malformed requests where there is a request body. 
It leverages the negative boundary cases from fields to generate 
requests to try and expects them to match the defined response for bad requests.

### Typo

This module checks for common integration issues when an
API is first being worked against such as urls which don't
exist

### Extra Verbs

This module checks to ensure consistency in response when
the api receives verbs it doesn't explicitly support

### Unused Fields

If any response fields are not returned during tests run
by previous modules, this will fail with a report
detailing unreturned response fields. When using this
module, it is recommended the good case module is also
used.

### Required Fields

This module tests out all the various invalid combinations of required fields to ensure consistent response

### Unexpected Fields

This module calls out if the API returns anything unexpected in its response

### Custom Modules

Do you want to do something with the definition which this gem currently does not support?
You can create your own test module and add it to the config instance class!
Just make sure it adheres to the following interface:

```ruby
module CustomModule
  def self.go contract
    # Your test code here
    # the contract object is the full definition created
  end

  def self.order
    # If your module needs to run first, put 0, if last, put 100.
    # Otherwise this can just be any number
  end
end  

config.with_module(CustomModule)
```

## Reporting

Right now the default reporting mechanism prints out to
the console all the issues which were found. You can
create your own reporting class (so long as it responds
to the same methods) or just extend the current one and
override the print method. Then set the report
tool in the config:

```ruby
config.with_reporter(new_reporter)
```

## Development

After checking out the repo, run `bin/setup` to install
dependencies. Then, run `rake spec` to run the tests.
You can also run `bin/console` for an interactive prompt
that will allow you to experiment.

To install this gem onto your local machine,
run `bundle exec rake install`.

## Contributing

Bug reports and pull requests are welcome on [GitHub repo](https://github.com/araneforseti/api-tester).

## Future Features Under Development

Check out our [Project Board](https://github.com/araneforseti/api-tester/projects/1) to see progress and where we are headed!
Feel free to leave feedback through Github's issue tracker

- Other Param Testing
  - Path params
  - Query
  - Headers
- Documentation
  - Generate Swagger-compliant documentation
  - Generate definitions from Swagger documentation

## License

The gem is available as open source under the terms
of the [MIT License](http://opensource.org/licenses/MIT).
