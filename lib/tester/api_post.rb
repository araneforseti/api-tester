require 'tester/request'
require 'tester/response'
require "tester/version"
require 'rest-client'
require 'tester/field_checker'
require 'json'
require 'tester/util/api_method'

class ApiPost < ApiMethod
  def go
    response = RestClient.post(url, @request.payload, @request.headers)
    response.code == expected_response.status_code &&
        response_matches(response)
  end
end