# frozen_string_literal: true

require 'slop'
require 'find'

require 'api-tester/version'
require 'api-tester/cli'
require 'api-tester/config'
require 'api-tester/contract'
require 'api-tester/logger'
require 'api-tester/runner'
require 'api-tester/world'
require 'api-tester/example'
require 'api-tester/expectation'
require 'api-tester/matcher'
require 'api-tester/formatter'
require 'api-tester/testers'
require 'api-tester/definition/endpoint'
require 'api-tester/definition/response'
require 'api-tester/definition/request'
require 'api-tester/definition/fields/array_field'
require 'api-tester/definition/fields/boolean_field'
require 'api-tester/definition/fields/email_field'
require 'api-tester/definition/fields/enum_field'
require 'api-tester/definition/fields/field'
require 'api-tester/definition/fields/object_field'
require 'api-tester/definition/fields/plain_array_field'
require 'api-tester/definition/fields/number_field'

# Tool for testing through API definitions
module ApiTester
  def self.config
    @config ||= Config.new
  end

  def self.enable_tester(tester)
    config.with_module(tester)
  end

  def self.logger
    @logger ||= Logger.new
  end

  def self.formatter
    @formatter ||= Formatter.new(logger)
  end

  def self.contract(name, base_url, &block)
    @contract = Contract.setup(name, base_url, &block)
  end

  def self.run
    @config.sorted_testers.each do |tester|
      tester.run @contract
    end
  end

  def self.go(contract, config)
    #    reporter = config.reporter

    #    config.testers.sort_by(&:order).each do |mod|
    #      reporter.add_reports mod.go contract
    #    end

    #    reporter.print
    #    reporter.reports.size.zero?
  end
end
