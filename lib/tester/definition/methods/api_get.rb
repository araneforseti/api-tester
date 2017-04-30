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

  def call params={}, request_params={}
    url = self.url
    if params != {}
      url = url + "?"

      query_params = []
      params.each do |key, value|
        query_params << "#{key}=#{value}"
      end
      url = url + query_params.join("&")
    end

    RestClient.get(url, request_params)
  end
end