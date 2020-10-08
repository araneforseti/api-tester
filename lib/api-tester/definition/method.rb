# frozen_string_literal: true

module ApiTester
  # Class for defining methods as part of an endpoint
  class Method
    attr_accessor :request
    attr_accessor :expected_response
    attr_accessor :verb

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
  end
end
