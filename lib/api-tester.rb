# frozen_string_literal: true

# Tool for testing through API definitions
module ApiTester
  def self.config
    @config ||= Config.new
  end

  def self.logger
    @logger ||= Logger.new
  end

  def self.formatter
    @formatter ||= Formatter.new(logger)
  end

  def self.contract(&block)
    contract << Contract.setup(&block)
  end

  def self.run
    @config.sorted_modules.each do |mod|
      mod.run contract
    end
  end

  def self.go(contract, config)
    reporter = config.reporter

    config.testers.sort_by(&:order).each do |mod|
      reporter.add_reports mod.go contract
    end

    reporter.print
    reporter.reports.size.zero?
  end
end
