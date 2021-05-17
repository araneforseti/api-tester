# frozen_string_literal: true

require 'api-tester/definition/boundary_case'

module ApiTester
  # Class for defining requests in a contract
  class Request
    attr_accessor :definition, :header_fields, :fields, :query_params

    def initialize
      self.fields = []
      self.header_fields = []
      self.query_params = []
    end

    def add_field(new_field)
      fields << new_field
      self
    end

    def add_query_param(new_query_param)
      query_params << new_query_param
      self
    end

    def default_query
      query_params.map { |param| "#{param.name}=#{param.default_value}" }.join('&')
    end

    def add_header_field(new_header)
      header_fields << new_header
      self
    end

    def payload
      response = {}
      fields.each do |field|
        if field.required == true
          response[field.name] = field.default_value
        end
      end
      response
    end

    def default_payload
      payload
    end

    def default_headers
      if header_fields != []
        headers
      else
        { content_type: :json, accept: :json }
      end
    end

    def headers
      header_response = {}
      header_fields.each do |header_field|
        header_response[header_field.name] = header_field.default_value
      end
      header_response
    end

    def cases
      boundary_cases = []
      fields.each do |field|
        field.negative_boundary_values.each do |value|
          bcase = BoundaryCase.new description: "Setting #{field.name} to #{value}",
                                   payload: altered_payload(field_name: field.name,
                                                            value: value),
                                   headers: default_headers
          boundary_cases.push bcase
        end
      end
      boundary_cases
    end

    def altered_payload(field_name:, value:)
      body = payload
      body[field_name] = value
      body
    end

    def altered_payload_with(fields)
      body = payload
      fields.each do |field|
        body[field[:name]] = field[:value]
      end
      body
    end
  end
end
