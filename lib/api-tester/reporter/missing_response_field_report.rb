module ApiTester
  # Report used for when response is missing a field
  class MissingResponseFieldReport
    attr_accessor :url
    attr_accessor :verb
    attr_accessor :expected_field
    attr_accessor :description

    def initialize(url:, verb:, expected_field:, description:)
      self.url = url
      self.verb = verb
      self.expected_field = expected_field
      self.description = description
    end

    def print
      puts "#{description}:"
      puts "   #{verb} #{url} is missing response field:"
      puts "      #{expected_field}"
    end
  end
end
