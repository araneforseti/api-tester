class Endpoint
  attr_accessor :methods
  attr_accessor :name

  def initialize name
    self.name = name
    self.methods = []
  end

  def add_method(new_method)
    self.methods << new_method
    self
  end
end