class MissingResponseFieldReport
  attr_accessor :url
  attr_accessor :expected_field

  def initialize(url, expected_field)
    self.url = url
    self.expected_field = expected_field
  end

  def print
    puts "#{self.url} is missing response field:"
    puts "      #{self.expected_field}"
  end
end