require 'tester/util/boundary_case'

class Request
  attr_accessor :definition
  attr_accessor :headers
  attr_accessor :fields

  def initialize
    self.fields = []
  end

  def add_field(new_field)
    self.fields << new_field
    self
  end

  def payload
    response = Hash.new
    self.fields.each do |field|
      response[field.name] = field.default_value
    end
    response
  end

  def cases
    boundary_cases = Array.new
    self.fields.each do |field|
      field.negative_boundary_values.each do |value|
        bcase = BoundaryCase.new("Setting #{field.name} to #{value}", altered_payload(field.name, value))
        boundary_cases.push(bcase)
      end
    end
    boundary_cases
  end

  def altered_payload field_name, value
    body = payload
    body[field_name] = value
    body
  end
end