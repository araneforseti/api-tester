module ApiTester
  def self.go contract, config
    reporter = config.reporter

    config.modules.sort_by{ |mod| mod.order }.each do |mod|
      reporter.add_reports mod.go contract
    end

    reporter.print
    reporter.reports.size == 0
  end
end