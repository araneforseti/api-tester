require 'tester/definition/response'

class Endpoint
  attr_accessor :methods
  attr_accessor :name
  attr_accessor :bad_request_response

  def initialize name
    self.name = name
    self.methods = []
    self.bad_request_response = Response.new 400
  end

  def add_method(new_method)
    self.methods << new_method
    self
  end
end