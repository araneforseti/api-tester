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
      self.modules << Format.new
      self.modules << GoodCase.new
      self.modules << Typo.new
      self.modules << UnusedFields.new
      self
    end

    def with_all_modules
      self.modules << Format.new
      self.modules << ExtraVerbs.new
      self.modules << GoodCase.new
      self.modules << Typo.new
      self.modules << UnusedFields.new
      self
    end
  end
end
