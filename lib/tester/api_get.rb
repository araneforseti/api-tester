require 'tester/request'
require 'tester/response'
require "tester/version"
require 'rest-client'
require 'json'
require 'tester/util/api_method'

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
end