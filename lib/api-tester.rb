module ApiTester
  def self.go definition, config
    reporter = config.reporter

    definition.endpoints.each do |endpoint|
      config.modules.sort_by{ |mod| mod.order }.each do |mod|
        mod.go endpoint, reporter
      end
    end

    reporter.print
    reporter.reports.size == 0
  end
end
