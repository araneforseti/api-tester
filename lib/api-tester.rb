# Tool for testing through API definitions
module ApiTester
  def self.go(contract, config)
    reporter = config.reporter

    config.modules.sort_by(&:order).each do |mod|
      reporter.add_reports mod.go contract
    end

    reporter.print
    reporter.reports.size.zero?
  end
end
