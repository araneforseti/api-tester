require 'tester/reporter/report'

class ApiReport
  attr_accessor :reports

  def initialize
    self.reports = []
  end

  def add_new url, request, expected_response, actual_response, description="A case"
    report = Report.new description, url, request, expected_response, actual_response
    self.reports << report
  end

  def add_new_report report
    self.reports << report
  end

  def print
    if self.reports.size > 0
      puts "Issues discovered: "
      self.reports.each do |report|
        report.print
      end
    else
      puts "No issues found"
    end
  end
end