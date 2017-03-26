class ObjectField < Field
  List<Fields> fields

  def initialize
    self.fields = []
  end

  def with_field(newField)
    fields.add newField
    return self
  end
end