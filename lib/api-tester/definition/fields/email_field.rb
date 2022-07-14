# frozen_string_literal: true

require 'api-tester/definition/fields/field'

module ApiTester
  # Class for defining email fields in contract
  class EmailField < Field
    def initialize(name:, default: 'test@test.com', required: false)
      super name: name, default: default, required: required
    end

    def negative_boundary_values
      super +
        [
          'string',
          123,
          1,
          0,
          true,
          false,
          {}
        ]
    end
  end
end
