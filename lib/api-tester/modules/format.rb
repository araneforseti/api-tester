require 'api-tester/reporter/status_code_report'
require 'api-tester/method_case_test'

module ApiTester
  # Checks the format constraints defined in contract
  module Format
    def self.go(contract)
      reports = []
      contract.endpoints.each do |endpoint|
        endpoint.methods.each do |method|
          cases = method.request.cases
          cases.each do |format_case|
            response = endpoint.call base_url: contract.base_url,
                                     method: method,
                                     payload: format_case.payload,
                                     headers: format_case.headers
            test = FormatTest.new response: response,
                                  payload: format_case.payload,
                                  expected_response: endpoint.bad_request_response,
                                  url: endpoint.url,
                                  verb: method.verb
            reports.concat test.check
          end
        end
      end
      reports
    end

    def self.order
      2
    end
  end

  # Test layout used by Format module
  class FormatTest < MethodCaseTest
    def initialize(response:, payload:, expected_response:, url:, verb:)
      super response: response,
            payload: payload,
            expected_response: expected_response,
            url: url,
            verb: verb,
            module_name: 'FormatModule'
    end
  end
end
