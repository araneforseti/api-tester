# frozen_string_literal: true

module ApiTester
  # Base class for field definitions
  class Field
    attr_accessor :name, :default, :required, :is_seen, :has_key

    def initialize(name:, required: false, has_key: true, default: 'string')
      self.name = name
      self.default = default
      self.required = required
      self.is_seen = 0
      self.has_key = has_key
    end

    def type
      'field'
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
