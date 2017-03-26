class Definition
  List<Fields> fields

  def initialize
    self.fields = []
  end

  def add_field(newField)
    fields.add newField
    return self
  end
end