require 'api-tester/definition/fields/field'

module ApiTester
  class EmailField < Field
    def initialize name:, default_value: "test@test.com"
      super name: name, default_value: default_value
    end

    def negative_boundary_values
      super +
      [
        "string",
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
