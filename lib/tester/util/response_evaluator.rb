class ResponseEvaluator
    attr_accessor :response_body
    attr_accessor :expected_response

    def initialize(actual_response_body, expected_response_fields)
        self.response_body = actual_response_body
        self.expected_response = expected_response_fields
    end

    def response_field_array
        field_array self.response_body
    end

    def expected_fields
        expected_field_array self.expected_response.body
    end

    def extra_fields
        response_field_array - expected_fields
    end

    def missing_fields
        expected_fields - response_field_array
    end

    def expected_field_array expected_fields
        fields = []
        expected_fields.each do |field|
            fields << field.name
            fields.concat(expected_field_array(field.fields).map{|i| "#{field.name}.#{i}"})
        end
        fields
    end

    def field_array object
        fields = []
        object.each do |key, value|
            fields << key.to_s
            fields.concat(field_array(value).map{|i| "#{key}.#{i}"})
        end
        fields
       rescue NoMethodError => e
        fields
    end
end
