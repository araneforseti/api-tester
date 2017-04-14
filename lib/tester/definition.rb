class Definition
  attr_accessor :fields

  def initialize
    @fields = []
  end

  def add_field(new_field)
    @fields << new_field
    self
  end
end