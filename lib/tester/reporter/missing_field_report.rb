class MissingFieldReport
  attr_accessor :description
  attr_accessor :url
  attr_accessor :request
  attr_accessor :expected_response
  attr_accessor :actual_response

  def initialize description, url, request, expected_field
    @description = description
    @url = url
    @request = request
    @expected_response = expected_response
    @actual_response = ""
  end

  def print
    puts "#{@description}: "
    puts "   Requested #{@url} with payload:"
    puts "      #{@request}"
    puts "   Missing field: "
    puts "      #{@expected_response}"
  end
end