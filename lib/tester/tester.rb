require "tester/version"
require 'rest-client'
require 'json'

class Tester
  attr_accessor :report
  attr_accessor :modules
  attr_accesoor :definition

  def initialize definition
    self.report = ApiReport.new
    self.modules = []
    self.definition = definition
  end

  def with_module(new_module)
    self.modules << new_module
    self
  end

  def with_default_modules
    self.modules << Boundary.new
    self
  end

  def go
    self.modules.each do |mod|
      mod.go self.definition, self.report
    end

    self.report.print
    self.report.reports.size == 0
  end
end