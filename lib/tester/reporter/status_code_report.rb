require 'tester/reporter/report'

class StatusCodeReport < Report
  attr_accessor :expected_status_code
  attr_accessor :actual_status_code

  def initialize description, url, request, expected_status_code, actual_status_code
    super description, url, request, expected_status_code, actual_status_code
    self.expected_status_code = expected_status_code
    self.actual_status_code = actual_status_code
  end
end