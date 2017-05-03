# Api::Tester
[![Build Status](https://travis-ci.org/araneforseti/api-tester.svg?branch=master)](https://travis-ci.org/araneforseti/api-tester)

Work in Progress! Use at own risk, definitely not ready for prime time!

This gem is intended to enable easy creation of tests for RESTful API services when given a contract.

##Intended Features Under Development

- Boundary Testing 
    - Boundary module: 
        - Checks syntax problems with the request and ensuring a consistent response
    - Good Case (name pending) module: 
        - Checks expected good requests will work (eg, number field should accept integers between 1 - 100)
    
##Intended Features Before "Release"

- Other Param Testing
    - Path
    - Query
    - Headers
- Endpoint Testing
    - Unused Response Fields
    - Invalid method names
    - Invalid method types
    
##What is this not intended for?

- Logic testing (eg, if X is between A and B, then Y is required)

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

Warning: This gem is still in alpha stage. Use at own risk understanding the contract will change until the first stable release

Define your endpoints using
```ruby
endpoint = Endpoint.new "Some name which is currently unused"
```

Define methods on endpoints

```ruby
get_method = ApiGet.new "http://yourbase.com/api/method"
```
Note: Currently only GET and POST have been created, but you can make your own so long as it has a "call" method which will execute the method given parameters

Define fields used by the method (both Request and Response)
```ruby
request = Request.new.add_field(Field.new "fieldName")
```
Note: Similar to methods, you can create your own fields. They need to repond to:
```ruby
field.has_subfields?
values_array = field.negative_boundary_values
```

Put them together and call go and off you go!
```ruby
request = Request.new.add_field(Field.new "fieldName")
response = Response.new(200).add_field(Field.new "fieldName")
get_method = ApiGet.new "http://yourbase.com/api/method"
get_method.request = request
get_method.expected_response = response
endpoint = Endpoint.new "Unused Name Sorry"
endpoint.add_method get_method
tester = ApiTester.new(endpoint).with_module(Boundary.new)
expect(tester.go).to be true

```

# Modules
## Boundary
This module will test out various edge cases and ensure error handling is consistent

## Good Case
This module ensures your 'default request' works appropriately

## Unused Fields
Note: Under construction, module unfinished

Note: If used, this should be the last module added to the tester.

If any response fields are not returned during tests run by previous modules, this will fail with a report detailing unreturned response fields. When using this module, it is recommended the good case module is also used.

# Reporting
Right now the default reporting mechanism prints out to the console all the issues which were found. You can create your own reporting class (so long as it responds to the same methods) or just extend the current one and override the print method. Then set the tester's report tool:
```ruby
tester.with_reporter(new_reporter)
```

# Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/araneforseti/api-tester.


# License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

