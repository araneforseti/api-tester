require 'tester/reporter/status_code_report'

class Boundary
  attr_accessor :report

  def set_report report
    self.report = report
  end

  def go definition, report
    set_report report

    definition.methods.each do |method|
      cases = method.request.cases
      cases.each do |boundary_case|
        response = method.call boundary_case.params
        self.response_matches(response, boundary_case, definition.bad_request)
      end
    end
  end

  def response_matches response, request, expected_response
    if response.code == expected_response.code
      check_response response, expected_response, request
    else
      incorrect_status_report response.code, expected_response.code, request, "Incorrect status"
    end
  end

  def incorrect_status_report status, expected_status, request, message
    report = StatusCodeReport.new message, request.url, request, expected_status, status
    self.report.add_new_report report
  end

  def check_response response, expected_response, request
    if response.body != expected_response.body
      self.report.add_new request.url, request, expected_response, response, 'Some fields missing'
    end
  end
end