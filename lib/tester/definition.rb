class Definition
  def initialize
    @fields = []
  end

  def add_field(newField)
    @fields.add newField
    return self
  end
end