require 'tester/reporter/status_code_report'
require 'tester/modules/module'

class Boundary < Module
  def go definition, report
    super

    definition.methods.each do |method|
      cases = method.request.cases
      cases.each do |boundary_case|
        response = method.call boundary_case.payload, boundary_case.headers
        self.response_matches(response, boundary_case, definition.bad_request_response, method)
      end
    end
  end
end