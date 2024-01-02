module ApiTester
  module Matcher
    class Equal
      def initialize(value)
        @value = value
      end

      def match?(expected)
        @expected = expected
        expected.eql?(@value)
      end

      def message
        "expected #{@expected.inspect} go #{@value.inspect}"
      end
    end
  end
end
