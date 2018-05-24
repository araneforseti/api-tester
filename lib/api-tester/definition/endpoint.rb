require 'api-tester/definition/response'
require 'api-tester/definition/method'
require 'api-tester/test_helper'
require 'rest-client'

module ApiTester
  class Endpoint
    attr_accessor :name
    attr_accessor :base_url
    attr_accessor :path_params
    attr_accessor :methods
    attr_accessor :test_helper
    attr_accessor :bad_request_response
    attr_accessor :not_allowed_response
    attr_accessor :not_found_response

    def initialize name, url
      self.base_url = url
      self.name = name
      self.methods = []
      self.path_params = []
      self.test_helper = ApiTester::TestHelper.new
      self.bad_request_response = ApiTester::Response.new 400
      self.not_allowed_response = ApiTester::Response.new 415
      self.not_found_response = ApiTester::Response.new 404
    end

    def url
      temp_url = self.base_url
      self.path_params.each do |param|
        temp_url.sub! "{#{param}}", self.test_helper.retrieve_param(param)
      end
      temp_url
    end

    def default_call
      self.test_helper.before
      method_defaults = self.methods[0].default_request
      method_defaults[:url] = self.url
      begin
        response = RestClient::Request.execute(method_defaults)
      rescue RestClient::ExceptionWithResponse => e
        response = e.response
      end
      self.test_helper.after
      response
    end

    def call method, payload={}, headers={}
      self.test_helper.before
      begin
        response = RestClient::Request.execute(method: method.verb, url: self.url, payload: payload, headers: headers)
      rescue RestClient::ExceptionWithResponse => e
        response = e.response
      end
      self.test_helper.after
      response
    end

    def add_method verb, response, request=Request.new()
      self.methods << ApiTester::Method.new(verb, response, request)
      self
    end

    def add_path_param param
      self.path_params << param
      self
    end

    def verbs
      self.methods.map(&:verb)
    end
  end
end
