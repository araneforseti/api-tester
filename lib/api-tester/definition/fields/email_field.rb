# frozen_string_literal: true

require 'securerandom'

require 'api-tester/definition/fields/field'

module ApiTester
  # Class for defining email fields in contract
  class EmailField < Field
    attr_accessor :randomize

    def initialize(name:, default: 'test@test.com', required: false, randomize: false)
      super name: name, default: default, required: required
      self.randomize = randomize
    end

    def default
      # Since many APIs have unique email checks, this allows us to generate hopefully unique emails
      if randomize
        "test#{SecureRandom.hex(10)}@test.com"
      else
        super
      end
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
