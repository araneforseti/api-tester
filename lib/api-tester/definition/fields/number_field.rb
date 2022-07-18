# frozen_string_literal: true

require 'api-tester/definition/fields/field'

module ApiTester
  # Class for defining numeric fields in contracts
  class NumberField < Field
    def initialize(name:, default: 5, required: false)
      super name: name, default: default, required: required
    end

    def negative_boundary_values
      super +
        [
          'string',
          true,
          false,
          {}
        ]
    end

    def good_cases
      [
        -1,
         0,
         1,
         100,
         9999,
         12345678901234567890
      ]
    end
  end
end
