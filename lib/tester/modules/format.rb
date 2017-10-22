require 'tester/reporter/status_code_report'
require 'tester/modules/module'

class Format < Module
  def go definition, report
    super

    definition.methods.each do |method|
      cases = method.request.cases
      cases.each do |format_case|
        response = method.call format_case.payload, format_case.headers
        test = FormatTest.new response, format_case.payload, definition.bad_request_response, method.url, method.verb
        self.report.reports.concat test.check
      end
    end

    report.reports == []
  end
end

class FormatTest < MethodCaseTest
    def initialize response, payload, expected_response, url, verb
        super response, payload, expected_response, url, verb, "FormatModule"
    end
end
