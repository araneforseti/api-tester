class Field
  attr_accessor :name
  attr_accessor :default_value

  def initialize name, default_value="string"
    @name = name
    @default_value = default_value
  end

  def has_subfields?
    false
  end

  def negative_boundary_values
    []
  end
end