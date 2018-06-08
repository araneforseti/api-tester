require 'api-tester/definition/fields/field'

module ApiTester
  class BooleanField < Field
    def initialize name:, default_value: true
      super name: name, default_value: default_value
    end

    def negative_boundary_values
      super +
      [
        "string",
        123,
        0,
        1,
        {}
      ]
    end
  end
end
