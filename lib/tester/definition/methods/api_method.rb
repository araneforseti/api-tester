require 'tester/definition/request'
require 'tester/definition/response'
require 'tester/reporter/status_code_report'
require 'tester/reporter/missing_field_report'
require 'tester/reporter/api_report'
require 'json'

class ApiMethod
  attr_accessor :request
  attr_accessor :expected_response
  attr_accessor :url

  def initialize url
    self.url = url
    self.request = Request.new
    self.expected_response = Response.new 200
  end

  def verb
    "None"
  end
end
