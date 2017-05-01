require 'tester/definition/fields/field'

class NumberField < Field
  def initialize(name, default_value=5)
    super(name, default_value)
  end

  def negative_boundary_values
    super +
    [
      "string",
      123,
      true,
      false,
      {}
    ]
  end
end