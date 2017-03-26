require 'tester/definition'

class Response
  attr_accessor :definition
  attr_accessor :status_code
  attr_accessor :body

  def initialize(status_code=200, body=[], definition=Definition.new)
    @definition = definition
    @status_code = status_code
    @body = body
  end
end