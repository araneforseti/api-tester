module ApiTester
  # Class for evaluating responses against what is expected
  class ResponseEvaluator
    attr_accessor :response_body
    attr_accessor :expected_response

    def initialize(actual_response_body, expected_response_fields)
      self.response_body = actual_response_body
      self.expected_response = expected_response_fields
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
        fields = fields.merge inner_expected_field(field.fields, field.name)
      end
      fields
    end

    def inner_expected_field(expected_fields, name)
      fields = {}
      expected_fields.each do |field|
        inner_name = "#{name}.#{field.name}"
        fields[inner_name] = field
        fields = fields.merge inner_expected_field(field.fields, inner_name)
      end
      fields
    end

    def field_array(object)
      fields = []
      object.each do |key, value|
        if value
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
