class Request
  attr_accessor :url
  attr_accessor :definition
  attr_accessor :headers
  attr_accessor :fields

  def initialize(url)
    @url = url
    @fields = []
  end

  def add_field(new_field)
    @fields << new_field
    self
  end

  def payload
    response = Hash.new
    @fields.each do |field|
      response[field.name] = field.default_value
    end
    response
  end
end