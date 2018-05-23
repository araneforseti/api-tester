require 'api-tester/reporter/status_code_report'
require 'api-tester/method_case_test'

module ApiTester
  class GoodCase
    def self.go contract
      reports = []

      contract.endpoints.each do |endpoint|
        endpoint.methods.each do |method|
          default_case = BoundaryCase.new endpoint.url, method.request.default_payload, method.request.default_headers
          response = endpoint.call method, default_case.payload, default_case.headers
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


  class GoodCaseTest < MethodCaseTest
      def initialize response, url, method
          super response, method.request.default_payload, method.expected_response, url, method.verb, "GoodCaseModule"
      end
  end
end
