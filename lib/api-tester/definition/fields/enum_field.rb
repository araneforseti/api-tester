require 'api-tester/definition/fields/field'

module ApiTester
  class EnumField < Field
    attr_accessor :acceptable_values

    def initialize name:, acceptable_values:, default_value: nil
      if default_value
        super name: name, default_value: default_value
      else
        super name: name, default_value: acceptable_values[0]
      end

      self.acceptable_values = acceptable_values
    end

    def negative_boundary_values
      super +
          [
              123,
              0,
              1,
              true,
              false,
              {}
          ]
    end
  end
end
