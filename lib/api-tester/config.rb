# frozen_string_literal: true

require 'api-tester/reporter/api_report'

module ApiTester
  # Config class for changing how the tool operates
  class Config
    attr_accessor :reporter, :modules

    def initialize(reporter: ApiTester::ApiReport.new)
      self.reporter = reporter
      self.modules = []
    end

    def with_reporter(reporter)
      self.reporter = reporter
      self
    end

    def with_module(new_module)
      modules << new_module
      self
    end

    def with_default_modules
      modules << Format
      modules << GoodCase
      modules << Typo
      modules << UnusedFields
      self
    end

    def with_all_modules
      modules << Format
      modules << ExtraVerbs
      modules << GoodCase
      modules << Typo
      modules << UnusedFields
      self
    end
  end
end
