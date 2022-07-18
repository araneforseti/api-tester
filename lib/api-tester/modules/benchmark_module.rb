# frozen_string_literal: true

require 'api-tester/reporter/response_time_report'

module ApiTester
  # Checks the response times collected during the test run
  # Note: Needs at least one calling module, like GoodCase, to work
  module BenchmarkModule
    def self.go(contract)
      reports = []

      contract.endpoints.each do |endpoint|
        longest_time = endpoint.longest_time
        longest_time[:time] = longest_time[:time] * 1000.0 # Convert from seconds to ms
        if longest_time[:time] > contract.max_time
          print 'F'
          reports << ResponseTimeReport.new(url: endpoint.url,
                                            verb: longest_time[:verb],
                                            payload: longest_time[:payload],
                                            max_time: contract.max_time,
                                            actual_time: longest_time[:time],
                                            description: 'BenchmarkModule')
        else
          print '.'
        end
      end

      reports
    end

    def self.order
      99
    end
  end
end
