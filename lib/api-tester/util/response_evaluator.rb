# frozen_string_literal: true

module ApiTester
  # Class for evaluating responses against what is expected
  class ResponseEvaluator
    attr_accessor :response_body
    attr_accessor :expected_response

    def initialize(actual_body:, expected_fields:)
      self.response_body = actual_body
      self.expected_response = expected_fields
    end

    def response_field_array
      field_array response_body
    end

    def expected_fields
      expected_fields_hash.keys
    end

    def seen_fields
      seen = []
      fields = response_field_array - extra_fields
      expected = expected_fields_hash
      fields.each do |field_key|
        seen << expected[field_key]
      end
      seen
    end

    def expected_fields_hash
      expected_field_array expected_response.body
    end

    def extra_fields
      response_field_array - expected_fields
    end

    def missing_fields
      expected_fields - response_field_array
    end

    def expected_field_array(expected_fields)
      fields = {}
      expected_fields.each do |field|
        fields[field.name] = field
        fields = fields.merge inner_expected_field(expected_fields: field.fields,
                                                   name: field.name)
      end
      fields
    end

    def inner_expected_field(expected_fields:, name:)
      fields = {}
      expected_fields.each do |field|
        inner_name = "#{name}.#{field.name}"
        fields[inner_name] = field
        fields = fields.merge inner_expected_field(expected_fields: field.fields,
                                                   name: inner_name)
      end
      fields
    end

    def field_array(object)
      fields = []

      object.each do |key, value|
        if key.respond_to?('each')
          fields.concat(field_array(key))
        elsif value == nil || value == 0 || value == false
          fields << key.to_s
          fields.concat(field_array(value).map { |i| "#{key}.#{i}" })
        elsif value.to_s[0] == '[' && value.to_s[-1] == ']' && !value.to_s.include?('=>')
          fields << key.to_s
        elsif value
          fields << key.to_s
          fields.concat(field_array(value).map { |i| "#{key}.#{i}" })
        else
          fields.concat(field_array(key))
        end
      end
      fields
    rescue NoMethodError
      fields
    end
  end
end
