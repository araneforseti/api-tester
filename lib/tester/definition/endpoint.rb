class Definition
  attr_accessor :methods

  def initialize name
    self.name = name
    self.methods = []
  end

  def add_method(new_method)
    self.methods << new_method
    self
  end
end