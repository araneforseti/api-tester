require 'tester/reporter/status_code_report'
require 'tester/modules/module'
require 'tester/method_case_test'

class GoodCase < Module
    def go definition, report
        super

        definition.methods.each do |method|
            test = GoodCaseTest.new method
            self.report.reports.concat test.check
        end

        self.report.reports == []
    end

    def order
        1
    end
end


class GoodCaseTest < MethodCaseTest
    def initialize(method)
        super method, method.request.default_payload
    end

    def response_code_report
        report = StatusCodeReport.new "GoodCaseModule - Default payload", self.url, self.payload, self.method.expected_response.code, self.response.code
        self.reports << report
    end

    def missing_field_report field
        report = Report.new "GoodCaseModule - Missing field #{field}", self.url, self.payload, self.method.expected_response, self.response
        self.reports << report
    end

    def extra_field_report field
        report = Report.new "GoodCaseModule - Found extra field #{field}", self.url, self.payload, self.method.expected_response, self.response
        self.reports << report
    end
end
