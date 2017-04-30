class Field
  attr_accessor :name
  attr_accessor :default_value
  attr_accessor :required

  def initialize name, default_value="string"
    self.name = name
    self.default_value = default_value
    self.required = false
  end

  def is_required
    self.required = true
    self
  end

  def is_not_required
    self.required = false
    self
  end

  def has_subfields?
    false
  end

  def negative_boundary_values
    cases = []
    if self.required
      cases << nil
    end
    cases
  end
end