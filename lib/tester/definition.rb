class Definition
  attr_accessor :fields

  def initialize
    self.fields = []
  end

  def add_field(new_field)
    self.fields << new_field
    self
  end
end