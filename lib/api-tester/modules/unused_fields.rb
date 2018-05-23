require 'api-tester/reporter/missing_response_field_report'
require 'api-tester/modules/module'

module ApiTester
  class UnusedFields < Module
    def go definition, report
      super

      definition.methods.each do |method|
        method.expected_response.body.each do |field|
          if field.is_seen == 0
            report.add_new_report MissingResponseFieldReport.new(definition.url, method.verb, field.name, "UnusedFieldsModule")
          end
        end
      end

      report.reports == []
    end

    def order
      99
    end
  end
end
