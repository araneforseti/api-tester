require 'api-tester/reporter/api_report'

module ApiTester
  class Config
    attr_accessor :reporter
    attr_accessor :modules

    def initialize reporter=ApiTester::ApiReport.new
      self.reporter = reporter
      self.modules = []
    end

    def with_reporter reporter
      self.reporter = reporter
      self
    end

    def with_module new_module
      self.modules << new_module
      self
    end

    def with_default_modules
      self.modules << Format
      self.modules << GoodCase
      self.modules << Typo
      self.modules << UnusedFields
      self
    end

    def with_all_modules
      self.modules << Format
      self.modules << ExtraVerbs
      self.modules << GoodCase
      self.modules << Typo
      self.modules << UnusedFields
      self
    end
  end
end
