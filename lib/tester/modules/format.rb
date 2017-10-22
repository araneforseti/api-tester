require 'tester/reporter/status_code_report'
require 'tester/modules/module'

class Format < Module
  def go definition, report
    super

    definition.methods.each do |method|
      cases = method.request.cases
      cases.each do |format_case|
        response = method.call format_case.payload, format_case.headers
        self.response_matches(response, format_case.payload, definition.bad_request_response, method, format_case.description)
      end
    end

    report.reports == []
  end
end
