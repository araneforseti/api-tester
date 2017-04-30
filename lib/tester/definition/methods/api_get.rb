require 'tester/definition/request'
require 'tester/definition/response'
require "tester/version"
require 'rest-client'
require 'json'
require 'tester/definition/methods/api_method'

class ApiGet < ApiMethod
  def call params={}, headers={}
    headers[:params] = params

    RestClient.get(self.url, headers)  { |real_response, request, result|
      real_response
    }
  end
end