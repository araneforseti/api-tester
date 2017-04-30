require 'tester/definition/request'
require 'tester/definition/response'
require "tester/version"
require 'rest-client'
require 'json'
require 'tester/definition/methods/api_method'

class ApiGet < ApiMethod
  def go
    response = RestClient.get(self.url, self.request.headers)
    if response.code != expected_response.status_code
      puts "Got #{response.code} when expecting #{expected_response.status_code}"
      return false
    end

    response_matches(response)
    super
  end

  def call request_params={}
    RestClient.get(self.url, request_params)
  end
end