require 'tester/fields/field'

class ObjectField < Field
  attr_accessor :fields

  def initialize name
    super(name)
    @fields = []
  end

  def with_field(newField)
    @fields << newField
    return self
  end
end