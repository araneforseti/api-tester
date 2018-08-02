module ApiReport
  # Report used for when an expected field is missing from a response
  class MissingFieldReport
    attr_accessor :description
    attr_accessor :url
    attr_accessor :request
    attr_accessor :expected_field
    attr_accessor :actual_response

    def initialize(description, url, request, expected_field)
      self.description = description
      self.url = url
      self.request = request
      self.expected_field = expected_field
      self.actual_response = ''
    end

    def print
      puts "#{description}: "
      puts "   Requested #{url} with payload:"
      puts "      #{request}"
      puts '   Missing field: '
      puts "      #{expected_field}"
    end
  end
end
