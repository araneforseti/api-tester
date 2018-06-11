require 'api-tester/definition/boundary_case'

module ApiTester
  class Request
    attr_accessor :definition
    attr_accessor :header_fields
    attr_accessor :fields
    attr_accessor :query_params

    def initialize
      self.fields = []
      self.header_fields = []
      self.query_params = []
    end

    def add_field new_field
      self.fields << new_field
      self
    end

    def add_query_param new_query_param
      self.query_params << new_query_param
      self
    end

    def default_query
      self.query_params.map{|param| "#{param.name}=#{param.default_value}"}.join("&")
    end

    def add_header_field new_header
      self.header_fields << new_header
      self
    end

    def payload
      response = Hash.new
      self.fields.each do |field|
        response[field.name] = field.default_value
      end
      response
    end

    def default_payload
      payload
    end

    def default_headers
      if self.header_fields != []
        self.headers
      else
        {content_type: :json, accept: :json}
      end
    end

    def headers
      header_response = {}
      self.header_fields.each do |header|
        header_response[header.name] = header.default_value
      end
      header_response
    end

    def cases
      boundary_cases = Array.new
      self.fields.each do |field|
        field.negative_boundary_values.each do |value|
          bcase = BoundaryCase.new("Setting #{field.name} to #{value}", altered_payload(field.name, value), default_headers)
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

    def altered_payload_with fields
      body = payload
      fields.each do |field|
        body[field[:name]] = field[:value]
      end
      body
    end
  end
end
