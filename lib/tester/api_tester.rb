require "tester/modules/boundary"
require 'tester/modules/good_case'
require 'tester/modules/unused_fields'
require 'tester/modules/typo'
require 'rest-client'
require 'json'

class ApiTester
  attr_accessor :report
  attr_accessor :modules
  attr_accessor :definition

  def initialize(definition)
    self.report = ApiReport.new
    self.modules = []
    self.definition = definition
  end

  def with_module(new_module)
    self.modules << new_module
    self
  end

  def with_reporter(reporter)
    self.report = reporter
    self
  end

  def with_default_modules
    self.modules << Boundary.new
    self.modules << GoodCase.new
    self.modules << Typo.new
    self.modules << UnusedFields.new
    self
  end

  #TODO: Find a way to test module orders
  def go
    self.modules.sort_by{ |mod| mod.order }.each do |mod|
      mod.go self.definition, self.report
    end

    self.report.print
    self.report.reports.size == 0
  end
end