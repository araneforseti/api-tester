module ApiTester
  class Field
      attr_accessor :name
      attr_accessor :default_value
      attr_accessor :required
      attr_accessor :is_seen

      def initialize name, default_value="string"
          self.name = name
          self.default_value = default_value
          self.required = false
          self.is_seen = 0
      end

      def is_required
          self.required = true
          self
      end

      def is_not_required
          self.required = false
          self
      end

      def has_subfields?
          false
      end

      def fields
          []
      end

      def negative_boundary_values
          cases = []
          if self.required
              cases << nil
          end
          cases
      end

      def seen
          self.is_seen += 1
      end

      def display_class
          self.class
      end
  end
end
