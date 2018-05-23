require 'api-tester/reporter/missing_response_field_report'

module ApiTester
  class UnusedFields
    def self.go definition
      reports = []

      definition.methods.each do |method|
        method.expected_response.body.each do |field|
          if field.is_seen == 0
            reports << MissingResponseFieldReport.new(definition.url, method.verb, field.name, "UnusedFieldsModule")
          end
        end
      end

      reports
    end

    def self.order
      99
    end
  end
end
