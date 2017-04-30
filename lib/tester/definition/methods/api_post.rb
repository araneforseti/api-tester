require 'tester/definition/request'
require 'tester/definition/response'
require "tester/version"
require 'rest-client'
require 'json'
require 'tester/definition/methods/api_method'
require 'tester/reporter/api_report'
require 'tester/reporter/status_code_report'

class ApiPost < ApiMethod
  attr_accessor :syntax_error_response

  def post json_payload, headers
    RestClient.post(self.url, json_payload, headers)  { |real_response, request, result|
      real_response
    }
  end

  def call body_params={}, request_params={}
    post body_params, request_params
  end
end