require 'api-tester/reporter/missing_field_report'

module ApiTester
  # Ensures all fields defined in contract are returned during test suite
  module UnusedFields
    def self.go(contract)
      reports = []

      contract.endpoints.each do |endpoint|
        endpoint.methods.each do |method|
          method.expected_response.body.each do |field|
            next unless field.is_seen.zero?
            reports << MissingFieldReport.new(url: endpoint.url,
                                              verb: method.verb,
                                              expected_field: field.name,
                                              description: 'UnusedFieldsModule')
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
