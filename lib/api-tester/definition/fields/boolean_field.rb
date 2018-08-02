require 'api-tester/definition/fields/field'

module ApiTester
  # Class for defining booleans in contract
  class BooleanField < Field
    def initialize(name:, default_value: true, required: false)
      super name: name, default_value: default_value, required: required
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
  end
end
