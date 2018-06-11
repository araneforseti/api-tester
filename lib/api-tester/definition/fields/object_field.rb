require 'api-tester/definition/fields/field'

module ApiTester
  class ObjectField < Field
      attr_accessor :fields

      def initialize name:, required:false
          super name: name, required: required
          self.fields = []
      end

      def with_field newField
          self.fields << newField
          self
      end

      def has_subfields?
          true
      end

      def default_value
          obj = Hash.new

          self.fields.each do |field|
              obj[field.name] = field.default_value
          end

          obj
      end

      def negative_boundary_values
          super +
            [
              "string",
              [],
              123,
              1,
              0,
              true,
              false
            ]
      end
  end
end
