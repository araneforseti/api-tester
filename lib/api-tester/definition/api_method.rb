class ApiMethod
  attr_accessor :request
  attr_accessor :expected_response
  attr_accessor :verb

  def initialize verb, response, request
    self.verb = verb
    self.request = request
    self.expected_response = response
  end
end
