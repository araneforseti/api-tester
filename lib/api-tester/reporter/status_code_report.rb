# frozen_string_literal: true

require 'api-tester/reporter/report'

module ApiTester
  # Report for when status code is different than expected
  class StatusCodeReport < Report
    attr_accessor :expected_status_code
    attr_accessor :actual_status_code

    def initialize(description:, url:, request:, expected_status_code:, actual_status_code:)
      super description: description,
            url: url,
            request: request,
            expected_response: expected_status_code,
            actual_response: actual_status_code
      self.expected_status_code = expected_status_code
      self.actual_status_code = actual_status_code
    end
  end
end
