# frozen_string_literal: true

module ApiTester
  # Standard report format for differing responses
  class Report
    attr_accessor :description, :url, :request, :expected_response, :actual_response

    def initialize(description:, url:, request:, expected_response:, actual_response:)
      self.description = description
      self.url = url
      self.request = request
      self.expected_response = expected_response
      self.actual_response = actual_response
    end

    def print
      puts "#{description}: "
      puts "   Requested #{url} with payload:"
      puts "      #{request.to_json}"
      puts '   Expecting: '
      puts "      #{expected_response}"
      puts '   Receiving: '
      puts "      #{actual_response}"
    end
  end
end
