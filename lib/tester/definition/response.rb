require 'tester/definition/definition'

class Response
  attr_accessor :status_code
  attr_accessor :body

  def initialize(status_code)
    self.status_code = status_code
    self.body = []
  end

  def add_field(new_field)
    self.body << new_field
    self
  end
end