# frozen_string_literal: true

module ApiTester
  # Report used for when response took too long
  class ResponseTimeReport
    attr_accessor :url, :verb, :payload, :max_time, :actual_time, :description

    def initialize(url:, verb:, payload:, max_time:, actual_time:, description:)
      self.url = url
      self.verb = verb
      self.payload = payload
      self.max_time = max_time
      self.actual_time = actual_time
    end

    def print
      puts "#{description}:"
      puts "   #{verb} #{url} took #{actual_time}ms, the max time is #{max_time}ms:"
      puts "     Payload:"
      puts "      #{payload}"
    end
  end
end
