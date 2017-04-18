class MissingFieldReport
  attr_accessor :description
  attr_accessor :url
  attr_accessor :request
  attr_accessor :expected_response
  attr_accessor :actual_response

  def initialize description, url, request, expected_field
    self.description = description
    self.url = url
    self.request = request
    self.expected_response = expected_response
    self.actual_response = ""
  end

  def print
    puts "#{self.description}: "
    puts "   Requested #{self.url} with payload:"
    puts "      #{self.request}"
    puts "   Missing field: "
    puts "      #{self.expected_response}"
  end
end