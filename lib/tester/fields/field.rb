class Field
  attr_accessor :name

  def initialize name
    @name = name
  end

  def has_subfields?
    false
  end
end