require 'tester/fields/field'

class ObjectField < Field
  attr_accessor :fields

  def initialize name
    super(name)
    @fields = []
  end

  def with_field(newField)
    @fields << newField
    self
  end

  def has_subfields?
    true
  end

  def default_value
    obj = Hash.new

    @fields.each do |field|
      obj[field.name] = field.default_value
    end

    obj
  end

  def negative_boundary_values
    [
        nil,
        "string",
        "",
        [],
        123,
        true,
        false
    ]
  end
end