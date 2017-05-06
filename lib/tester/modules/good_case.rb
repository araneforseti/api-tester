require 'tester/reporter/status_code_report'
require 'tester/modules/module'

class GoodCase < Module
  def go definition, report
    super

    definition.methods.each do |method|
      payload = method.request.default_payload
      response = method.call payload, method.request.default_headers
      self.response_matches(response, payload, method.expected_response, method)
    end

    report.reports == []
  end

  def order
    1
  end
end