require 'tester/reporter/status_code_report'
require 'tester/modules/module'
require 'tester/method_case_test'

class GoodCase < Module
    def go definition, report
        super

        definition.methods.each do |method|
            default_case = BoundaryCase.new definition.url, method.request.default_payload, method.request.default_headers
            response = self.call method, definition, default_case
            test = GoodCaseTest.new response, definition.url, method
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
