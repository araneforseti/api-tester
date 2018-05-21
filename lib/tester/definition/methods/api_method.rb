require 'tester/definition/request'
require 'tester/definition/response'
require 'json'

class ApiMethod
  attr_accessor :request
  attr_accessor :expected_response

  def initialize
    self.request = Request.new
    self.expected_response = Response.new 200
  end

  def call
    throw "Not implemented"
  end

  def verb
    "None"
  end
end
