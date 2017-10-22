class MissingResponseFieldReport
  attr_accessor :url
  attr_accessor :expected_field
  attr_accessor :description

  def initialize(url, expected_field, description)
    self.url = url
    self.expected_field = expected_field
    self.description = description
  end

  def print
    puts "#{self.description} - #{self.url} is missing response field:"
    puts "      #{self.expected_field}"
  end
end
