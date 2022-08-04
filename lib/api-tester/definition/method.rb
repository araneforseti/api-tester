# frozen_string_literal: true

module ApiTester
  # Class for defining methods as part of an endpoint
  class Method
    attr_accessor :request, :expected_response, :verb

    def initialize(verb:, response:, request:)
      self.verb = verb
      self.request = request
      self.expected_response = response
    end

    def default_request
      { method: verb,
        payload: request.default_payload,
        headers: request.default_headers }
    end

    def add_request(&block)
      request = ApiTester::Request.new
      request.instance_eval(&block)
      self.request = request
    end

    def add_response(&block)
      response = ApiTester::Response.new
      response.instance_eval(&block)
      self.expected_response = response
    end
  end
end
