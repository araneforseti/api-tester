# Api::Tester
[![Build Status](https://travis-ci.org/araneforseti/api-tester.svg?branch=master)](https://travis-ci.org/araneforseti/api-tester)

Work in Progress! Use at own risk, definitely not ready 
for prime time! To isolate your project from the changes, be sure to specify which gem version you use.

This gem is intended to enable easy creation of tests for 
RESTful API services when given a contract.

Check out [API Tester Example](https://github.com/araneforseti/example_api-tester) for an example in action

# Feature Plan
## Under Development
Check out our [Trello Board](https://trello.com/b/R3RtsJ2A/api-tester) to see progress and where we are headed!
Feel free to leave feedback through github's issue tracker

- Format module: 
     - Checks syntax problems with the request and 
        ensuring a consistent response
- Typo module:
     - Tests incorrect verbs and simulates typos in the url
- Good Case (name pending) module: 
     - Checks expected good requests will work 
        (eg, number field should accept integers 
        between 1 - 100)
- Unused Fields module:
    - A module which runs after all the others and reports on any response fields which were never returned
    
## Intended Features Before "Release"

- Other Param Testing
    - Path
    - Query
    - Headers
- Endpoint Testing
    - Unused Response Fields
    - Invalid method names
    - Invalid method types
- Documentation
    - Generate Swagger-compliant documentation
    - Generate definitions from Swagger documentation
    
## What is this not intended for?

- Logic testing (eg, if X is between A and B, then Y is 
required)

# Usage
## Installation

Add this line to your application's Gemfile (Note: specify your version due to gem's currently volatile nature):

```ruby
gem 'api-tester', '0.0.2'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install api-tester

## Usage in Code

Warning: This gem is still in alpha stage. Use at own risk 
understanding the contract will change until the first 
stable release

Define your endpoints using
```ruby
endpoint = Endpoint.new "Some name which is currently unused", "http://yourbase.com/api/endpoint"
```

Define methods on endpoints

```ruby
get_method = ApiGet.new 
```
Note: Currently only GET and POST have been created, but 
you can make your own so long as it has `call` and `verb` methods 
which will execute the method given parameters

Define fields used by the method (both Request and Response)
```ruby
request = Request.new.add_field(Field.new "fieldName")
```
Note: Similar to methods, you can create your own fields. 
They need to repond to:
```ruby
field.has_subfields?
values_array = field.negative_boundary_values
```

Put them together and call go and off you go!
```ruby
request = Request.new.add_field(Field.new "fieldName")
expected_response = Response.new(200).add_field(Field.new "fieldName")
get_method = ApiGet.new 
get_method.request = request
get_method.expected_response = expected_response
endpoint = Endpoint.new "Unused Name", "http://yourbase.com/api/endpoint"
endpoint.add_method get_method
tester = ApiTester.new(endpoint).with_module(Format.new)
expect(tester.go).to be true

```

## Dependencies

If your API has some setup which needs to happen before or after each call for a particular endpoint, you can use the TestHelper interface:

```ruby
class InfoCreator < TestHelper
  def before
    puts "This code runs before every call"
  end

  def after
    puts "This code runs after every call"
  end
end

tester = ApiTester.new(endpoint)
tester.test_helper = InfoCreator.new
expect(tester.go).to be true
```  

# Modules
## Boundary
This module will test out various edge cases and 
ensure error handling is consistent

## Good Case
This module ensures your 'default request' works 
appropriately

## Typo
This module checks for common integration issues when an 
API is first being worked against such as urls which don't 
exist and HTTP Verb against a url which does not support it

## Unused Fields
If any response fields are not returned during tests run
by previous modules, this will fail with a report 
detailing unreturned response fields. When using this 
module, it is recommended the good case module is also 
used.

# Reporting
Right now the default reporting mechanism prints out to 
the console all the issues which were found. You can 
create your own reporting class (so long as it responds 
to the same methods) or just extend the current one and 
override the print method. Then set the tester's report 
tool:
```ruby
tester.with_reporter(new_reporter)
```

# Development

After checking out the repo, run `bin/setup` to install 
dependencies. Then, run `rake spec` to run the tests. 
You can also run `bin/console` for an interactive prompt 
that will allow you to experiment.

To install this gem onto your local machine, 
run `bundle exec rake install`.

## Contributing

Bug reports and pull requests are welcome on GitHub at 
https://github.com/araneforseti/api-tester.


# License

The gem is available as open source under the terms 
of the [MIT License](http://opensource.org/licenses/MIT).

