require 'tester/request'
require 'tester/response'
require "tester/version"
require 'rest-client'
require 'tester/field_checker'
require 'json'
require 'tester/util/api_method'

class ApiGet < ApiMethod
  def go
    response = RestClient.get(url, @request.headers)
    response.code == expected_response.status_code &&
        response_matches(response)
  end
end