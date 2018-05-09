require 'tester/definition/response'

class Endpoint
  attr_accessor :url
  attr_accessor :methods
  attr_accessor :name
  attr_accessor :test_helper
  attr_accessor :bad_request_response
  attr_accessor :not_allowed_response
  attr_accessor :not_found_response

  def initialize name, url
    self.url = url
    self.name = name
    self.methods = []
    self.test_helper = TestHelper.new
    self.bad_request_response = Response.new 400
    self.not_allowed_response = Response.new 415
    self.not_found_response = Response.new 404
  end

  def add_method(new_method)
    self.methods << new_method
    self
  end
end
