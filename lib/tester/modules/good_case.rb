require 'tester/reporter/status_code_report'
require 'tester/modules/module'

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


class GoodCaseTest
    attr_accessor :method
    attr_accessor :payload
    attr_accessor :response
    attr_accessor :reports
    attr_accessor :url

    def initialize(method)
        self.method = method
        self.payload = method.request.default_payload
        self.response = method.call payload, method.request.default_headers
        self.reports = []
        self.url = "#{method.verb} #{method.url}"
    end

    def response_code_report
        StatusCodeReport.new "GoodCaseModule: Default payload", self.url, self.payload, self.method.expected_response.code, self.response.code
    end

    def missing_field_report field
        report = Report.new "GoodCaseModule: missing field #{field}", self.url, self.payload, self.method.expected_response, self.response
        self.reports << report
    end

    def extra_field_report field
        report = Report.new "GoodCaseModule: found extra field #{field}", self.url, self.payload, self.method.expected_response, self.response
        self.reports << report
    end

    def check
        if check_response_code
            evaluator = ResponseEvaluator.new json_parse(self.response.body), self.method.expected_response
            evaluator.missing_fields.map{|field| missing_field_report(field)}
            evaluator.extra_fields.map{|field| extra_field_report(field)}
            increment_fields evaluator.missing_fields
        end
        return self.reports
    end

    def check_response_code
        if response.code != method.expected_response.code
            self.reports << response_code_report
            return false
        end
        return true
    end

    def increment_fields missing_fields
        self.method.expected_response.body.each do |field|
            if !(missing_fields.include?(field.name))
                field.seen
            end 
        end
    end

    def json_parse body
        JSON.parse!(body)
      rescue JSON::ParserError
        body
    end
end
