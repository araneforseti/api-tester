require 'tester/definition/fields/field'

class BooleanField < Field
  def initialize(name, default_value=true)
    super(name, default_value)
  end

  def negative_boundary_values
    super +
    [
      "string",
      123,
      0,
      1,
      {}
    ]
  end
end