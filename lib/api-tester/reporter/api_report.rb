require 'api-tester/reporter/report'

module ApiTester
  # class for dealing with reports generated by the modules during test suite
  class ApiReport
    attr_accessor :reports

    def initialize
      self.reports = []
    end

    def add_new(url, request, expected_response, actual_response, description = 'case')
      report = Report.new description,
                          url,
                          request,
                          expected_response,
                          actual_response
      reports << report
    end

    def add_new_report(report)
      reports << report
    end

    def add_reports(reports)
      reports.concat reports
    end

    def print
      if reports.size.zero?
        puts "Issues discovered: #{reports.size}"
        reports.each do |report|
          report.print
          puts '\n'
          puts '\n'
        end
      else
        puts 'No issues found'
      end
    end
  end
end
