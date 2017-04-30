require 'tester/definition/response'

class Endpoint
  attr_accessor :methods
  attr_accessor :name
  attr_accessor :good_response

  def initialize name
    self.name = name
    self.methods = []
    self.good_response = Response.new 200
  end

  def set_good_response response
    self.good_response = response
  end

  def add_method(new_method)
    self.methods << new_method
    self
  end
end