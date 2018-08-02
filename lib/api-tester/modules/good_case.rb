require 'api-tester/reporter/status_code_report'
require 'api-tester/method_case_test'

module ApiTester
  # Checks the good case as defined in contract
  module GoodCase
    def self.go(contract)
      reports = []

      contract.endpoints.each do |endpoint|
        endpoint.methods.each do |method|
          default_case = BoundaryCase.new endpoint.url, method.request.default_payload, method.request.default_headers
          response = endpoint.call base_url: contract.base_url, method: method, payload: default_case.payload, headers: default_case.headers
          test = GoodCaseTest.new response, endpoint.url, method
          reports.concat test.check
        end
      end
      reports
    end

    def self.order
      1
    end
  end

  # Test layout used by module
  class GoodCaseTest < MethodCaseTest
    def initialize(response, url, method)
      super response,
            method.request.default_payload,
            method.expected_response,
            url,
            method.verb,
            'GoodCaseModule'
    end
  end
end
