class Report
  attr_accessor :description
  attr_accessor :url
  attr_accessor :request
  attr_accessor :expected_response
  attr_accessor :actual_response

  def initialize description, url, request, expected_response, actual_response
    @description = description
    @url = url
    @request = request
    @expected_response = expected_response
    @actual_response = actual_response
  end

  def print
    puts "#{@description}: "
    puts "   Requested #{@url} with payload:"
    puts "      #{@request}"
    puts "   Expecting: "
    puts "      #{@expected_response}"
    puts "   Receiving: "
    puts "      #{@actual_response}"
  end
end