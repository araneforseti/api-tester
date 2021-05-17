# frozen_string_literal: true

module ApiTester
  # Base class for field definitions
  class Field
    attr_accessor :name, :default_value, :required, :is_seen

    def initialize(name:, required: false, default_value: 'string')
      self.name = name
      self.default_value = default_value
      self.required = required
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

    def subfields?
      false
    end

    def fields
      []
    end

    def negative_boundary_values
      cases = []
      cases << nil if required
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
