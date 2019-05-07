require 'api-tester/reporter/report'

module ApiTester
  # class for dealing with reports generated by the modules during test suite
  class ApiReport
    attr_accessor :reports

    def initialize
      self.reports = []
    end

    def add_new(url:, request:, expected_response:, actual_response:, description: 'case')
      report = Report.new description,
                          url,
                          request,
                          expected_response,
                          actual_response
      reports << report
    end

    def add_new_report(report)
      self.reports << report
    end

    def add_reports(reports)
      reports.each do |report|
        add_new_report(report)
      end
    end

    def print
      if self.reports.size.zero?
        puts 'No issues found'
      else
        puts "Issues discovered: #{reports.size}"
        reports.each do |report|
          report.print
          puts '\n'
          puts '\n'
        end
        puts "Total issues: #{reports.size}"
      end
    end
  end
end
