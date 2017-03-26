class Definition
  attr_accessor :fields

  def initialize
    @fields = []
  end

  def add_field(newField)
    @fields << newField
    return self
  end
end