require 'tester/reporter/status_code_report'
require 'tester/test_helper'

class Module
  attr_accessor :report

  def set_report report
    self.report = report
  end

  def go definition, report
    set_report report
  end

  def order
    5
  end

  def before definition
    definition.test_helper.before
  end

  def after definition
    definition.test_helper.after
  end

  def call method, definition, format_case
    self.before definition
    response = method.call definition.url, format_case.payload, format_case.headers
    self.after definition
    response
  end
end
