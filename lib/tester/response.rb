require 'tester/definition'

class Response
  attr_accessor :definition
  attr_accessor :status_code
  attr_accessor :body

  def initialize
    @definition = Definition.new
  end
end