require 'api-tester/reporter/missing_response_field_report'

module ApiTester
  # Module ensuring all fields defined in contract are returned during test suite
  module UnusedFields
    def self.go(contract)
      reports = []

      contract.endpoints.each do |endpoint|
        endpoint.methods.each do |method|
          method.expected_response.body.each do |field|
            if field.is_seen.zero?
              reports << MissingResponseFieldReport.new(endpoint.url, 
                                                        method.verb,
                                                        field.name,
                                                        'UnusedFieldsModule')
            end
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
