# frozen_string_literal: true

require 'api-tester/definition/fields/field'

module ApiTester
  # Class for defining booleans in contract
  class BooleanField < Field
    def initialize(name:, default: true, required: false)
      super name: name, default: default, required: required
    end

    def negative_boundary_values
      super +
        [
          'string',
          123,
          0,
          1,
          {}
        ]
    end

    def good_cases
      [
        true,
        false
      ]
    end
  end
end
