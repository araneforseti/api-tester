module ApiTester
  class World
    def expect(value)
      Expectation.new(value)
    end

    def equal(value)
      Matcher::Equal.new(value)
    end
  end
end
