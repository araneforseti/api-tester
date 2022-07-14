# frozen_string_literal: true

require 'api-tester/definition/fields/field'

module ApiTester
  # Class used for defining array fields
  class ArrayField < Field
    attr_accessor :fields

    def initialize(name:, required: false, has_key: true)
      super name: name, required: required, has_key: has_key
      self.fields = []
    end

    def with_field(new_field)
      fields << new_field
      self
    end

    def subfields?
      true
    end

    def type
      "array"
    end

    def default_value
      return [] if fields.size.zero?

      obj = {}
      fields.each do |field|
        obj[field.name] = field.default_value
      end
      [obj]
    end

    def negative_boundary_values
      super +
        [
          'string',
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
