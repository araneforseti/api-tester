require 'tester/definition/request'
require 'tester/definition/response'
require "tester/version"
require 'rest-client'
require 'json'
require 'tester/definition/methods/api_method'

class ApiGet < ApiMethod
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

    RestClient.get(self.url, request_params)  { |real_response, request, result|
      real_response
    }
  end
end