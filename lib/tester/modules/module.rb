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
end
