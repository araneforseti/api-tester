# frozen_string_literal: true

require 'api-tester/definition/fields/field'

module ApiTester
  # Class for defining enumerators
  class EnumField < Field
    attr_accessor :acceptable_values

    def initialize(name:, acceptable_values:, default: nil, required: false)
      if default
        super name: name, default: default, required: required
      else
        super name: name, default: acceptable_values[0], required: required
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

    def good_cases
      acceptable_values
    end
  end
end
