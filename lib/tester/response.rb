require 'tester/definition'

class Response
  attr_accessor :status_code
  attr_accessor :body

  def initialize(status_code)
    @status_code = status_code
    @body = []
  end

  def add_field(new_field)
    @body << new_field
    self
  end
end