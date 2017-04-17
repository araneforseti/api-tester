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

  def default_value
    if @fields.size == 0
      return []
    end

    obj = Hash.new
    @fields.each do |field|
      obj[field.name] = field.default_value
    end
    [obj]
  end
end