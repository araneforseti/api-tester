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
    if response.code != expected_response.status_code
      puts "Got #{response.code} when expecting #{expected_response.status_code}"
      return false
    end

    return response_matches(response)
  end
end