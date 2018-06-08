require 'api-tester/reporter/status_code_report'
require 'api-tester/method_case_test'

module ApiTester
  class Format
    def self.go contract
      reports = []
      contract.endpoints.each do |endpoint|
        endpoint.methods.each do |method|
          cases = method.request.cases
          cases.each do |format_case|
            response = endpoint.call base_url: contract.base_url, method: method, payload: format_case.payload, headers: format_case.headers
            test = FormatTest.new response, format_case.payload, endpoint.bad_request_response, endpoint.url, method.verb
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

  class FormatTest < MethodCaseTest
      def initialize response, payload, expected_response, url, verb
          super response, payload, expected_response, url, verb, "FormatModule"
      end
  end
end
