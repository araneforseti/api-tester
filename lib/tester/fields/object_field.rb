require 'tester/fields/field'

class ObjectField < Field
  attr_accessor :fields

  def initialize name
    super(name)
    self.fields = []
  end

  def with_field(newField)
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
    [
        "string",
        [],
        123,
        true,
        false
    ]
  end
end