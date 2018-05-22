require 'tester/reporter/status_code_report'
require 'tester/modules/module'
require 'tester/method_case_test'

class GoodCase < Module
    def go endpoint, report
        super

        endpoint.methods.each do |method|
            default_case = BoundaryCase.new endpoint.url, method.request.default_payload, method.request.default_headers
            response = endpoint.call method, default_case.payload, default_case.headers
            test = GoodCaseTest.new response, endpoint.url, method
            self.report.reports.concat test.check
        end

        self.report.reports == []
    end

    def order
        1
    end
end


class GoodCaseTest < MethodCaseTest
    def initialize response, url, method
        super response, method.request.default_payload, method.expected_response, url, method.verb, "GoodCaseModule"
    end
end
