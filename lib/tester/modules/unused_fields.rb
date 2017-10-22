require 'tester/reporter/missing_response_field_report'
require 'tester/modules/module'

class UnusedFields < Module
  def go definition, report
    super

    definition.methods.each do |method|
      method.expected_response.body.each do |field|
        if field.is_seen == 0
          report.add_new_report MissingResponseFieldReport.new(method.url, field.name, "UnusedFieldsModule")
        end
      end
    end

    report.reports == []
  end

  def order
    99
  end
end
