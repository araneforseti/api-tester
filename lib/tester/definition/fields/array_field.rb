require 'tester/definition/fields/field'

class ArrayField < Field
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
    if self.fields.size == 0
      return []
    end

    obj = Hash.new
    self.fields.each do |field|
      obj[field.name] = field.default_value
    end
    [obj]
  end

  def negative_boundary_values
    super +
    [
      "string",
      123,
      0,
      1,
      true,
      false,
      {}
    ]
  end
end