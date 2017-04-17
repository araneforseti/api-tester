class BoundaryCase
  attr_accessor :payload
  attr_accessor :description

  def initialize description, payload
    @description = description
    @payload = payload
  end
end