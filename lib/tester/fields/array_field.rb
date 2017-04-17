require 'tester/fields/field'

class ArrayField < Field
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
end