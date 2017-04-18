class BoundaryCase
  attr_accessor :payload
  attr_accessor :description

  def initialize description, payload
    self.description = description
    self.payload = payload
  end
end