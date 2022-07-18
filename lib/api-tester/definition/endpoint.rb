# frozen_string_literal: true

require 'api-tester/definition/response'
require 'api-tester/definition/method'
require 'api-tester/test_helper'
require 'benchmark'
require 'rest-client'
require 'json'
require 'pry'

module ApiTester
  # Class for defining and interacting with endpoints in a contract
  class Endpoint
    attr_accessor :name, :relative_url, :path_params, :methods, :test_helper, :bad_request_response, :not_allowed_response, :not_found_response, :longest_time, :required_headers

    def initialize(name:, relative_url:)
      self.relative_url = relative_url
      self.name = name
      self.methods = []
      self.path_params = []
      self.longest_time = { time: 0 }
      self.test_helper = ApiTester::TestHelper.new ''
      self.bad_request_response = ApiTester::Response.new status_code: 400
      self.not_allowed_response = ApiTester::Response.new status_code: 415
      self.not_found_response = ApiTester::Response.new status_code: 404
      self.required_headers = {}
    end

    def display_url
      relative_url
    end

    def url
      temp_url = relative_url.clone
      path_params.each do |param|
        value = test_helper.retrieve_param(param).to_s
        temp_url = relative_url.sub "{#{param}}", value
      end
      temp_url
    end

    def default_call(base_url)
      test_helper.before
      method_defaults = methods[0].default_request
      method_defaults[:url] = "#{base_url}#{url}"
      begin
        response = nil
        time = Benchmark.measure {
          response = RestClient::Request.execute(method_defaults)
        }
        if time.real > longest_time[:time] && longest_time[:time] > 0
          longest_time[:time] = time.real
          longest_time[:payload] = payload.to_json
          longest_time[:verb] = method.verb
        end
      rescue RestClient::ExceptionWithResponse => e
        response = e.response
      end
      test_helper.after
      response
    end

    def call(base_url:, method:, query: '', payload: {}, headers: {})
      test_helper.before
      call_url = query ? "#{base_url}#{url}?#{query}" : "#{base_url}#{url}"
      begin
        response = nil
        time = Benchmark.measure {
          response = RestClient::Request.execute(method: method.verb,
                                                 url: call_url,
                                                 payload: payload.to_json,
                                                 headers: headers)
        }
        if time.real > longest_time[:time]
          longest_time[:time] = time.real
          longest_time[:payload] = payload.to_json
          longest_time[:verb] = method.verb
        end
      rescue RestClient::ExceptionWithResponse => e
        response = e.response
      end
      test_helper.after
      response
    end

    def add_method(verb:, response:, request: Request.new)
      methods << ApiTester::Method.new(verb: verb,
                                       response: response,
                                       request: request)
      self
    end

    def add_path_param(param)
      path_params << param
      self
    end

    def verbs
      methods.map(&:verb)
    end
  end
end
