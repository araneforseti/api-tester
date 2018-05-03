require 'tester/reporter/status_code_report'
require 'tester/test_helper'

class Module
  attr_accessor :report
  attr_accessor :test_helper

  def initialize
    self.test_helper = TestHelper.new
  end

  def set_report report
    self.report = report
  end

  def go definition, report
    set_report report
  end

  def order
    5
  end

  def before
    self.test_helper.before
  end

  def after
    self.test_helper.after
  end

end
