require 'tester/reporter/report'

class ApiReport
  def initialize
    @reports = []
  end

  def add_new url, request, expected_response, actual_response, description="A case"
    report = Report.new description, url, request, expected_response, actual_response
    @reports << report
  end

  def add_new_report report
    @reports << report
  end

  def reports
    @reports
  end

  def print
    if @reports.size > 0
      puts "Issues discovered: "
      @reports.each do |report|
        report.print
      end
    else
      puts "No issues found"
    end
  end
end