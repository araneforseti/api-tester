require 'pry'

module ApiTester
  module RequiredFields
    def self.go contract
      reports = []
      contract.endpoints.each do |endpoint|
        endpoint.methods.each do |method|
          request_def = method.request
          method.request.fields.each do |field|
            if field.required then
              request = request_def.altered_payload field.name, nil
              response = endpoint.call base_url: contract.base_url, method: method, payload: request, headers: request_def.default_headers
              test = RequiredFieldsTest.new response, request, endpoint.bad_request_response, endpoint.url, method.verb
              reports.concat test.check
            end
          end
        end
      end

      reports
    end

    def self.order
      5
    end
  end

  class RequiredFieldsTest < MethodCaseTest
      def initialize response, payload, expected_response, url, verb
          super response, payload, expected_response, url, verb, "RequiredFieldsModule"
      end
  end
end