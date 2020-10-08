# frozen_string_literal: true

require 'api-tester/definition/fields/field'

module ApiTester
  # Class for defining plain arrays
  class PlainArrayField < Field
    def initialize(name:, default_value: [], required: false)
      super name: name, default_value: default_value, required: required
    end

    def negative_boundary_values
      super +
        [
          'string',
          123,
          0,
          1,
          {},
          true,
          false
        ]
    end
  end
end
