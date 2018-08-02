require 'api-tester/definition/fields/field'

module ApiTester
  # Class for defining numeric fields in contracts
  class NumberField < Field
    def initialize(name:, default_value: 5, required: false)
      super name: name, default_value: default_value, required: required
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
  end
end
