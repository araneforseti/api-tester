class Field
  attr_accessor :name

  def initialize name
    @name = name
  end

  def has_subfields?
    false
  end

  def default_value
    "1"
  end
end