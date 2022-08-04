# frozen_string_literal: true

require 'api-tester/reporter/status_code_report'
require 'api-tester/method_case_test'

module ApiTester
  # Checks the good case as defined in contract
  class GoodCase
    def self.go(contract)
      reports = []

      contract.endpoints.each do |endpoint|
        endpoint.methods.each do |method|
          default_case = BoundaryCase.new description: contract.base_url + endpoint.display_url,
                                          payload: method.request.default_payload,
                                          headers: method.request.default_headers
          response = endpoint.call base_url: contract.base_url,
                                   method: method,
                                   payload: default_case.payload,
                                   headers: default_case.headers
          test = GoodCaseTest.new response: response,
                                  url: contract.base_url + endpoint.url,
                                  method: method
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
    def initialize(response:, url:, method:)
      super response: response,
            payload: method.request.default_payload,
            expected_response: method.expected_response,
            url: url,
            verb: method.verb,
            module_name: 'GoodCaseModule'
    end
  end
end
