require 'tester/definition/fields/field'

class EnumField < Field
  attr_accessor :acceptable_values

  def initialize name, acceptable_values, default_value=nil
    if default_value
      super name, default_value
    else
      super name, acceptable_values[0]
    end

    self.acceptable_values = acceptable_values
  end

  def negative_boundary_values
    super +
        [
            123,
            0,
            1,
            true,
            false,
            {}
        ]
  end
end