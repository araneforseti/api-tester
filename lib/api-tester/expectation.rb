module ApiTester
  class Expectation
    def initialize(value)
      @value = value
    end

    def to(matcher)
      raise(matcher.message) unless matcher.match?(@value)
    end
  end
end
