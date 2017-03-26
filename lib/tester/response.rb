require 'tester/definition'

class Response
  attr_accessor :definition
  attr_accessor :status_code

  def initialize
    @definition = Definition.new
  end
end