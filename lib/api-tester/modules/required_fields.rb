require 'pry'

module ApiTester
  module RequiredFields
    def self.go contract
      reports = []
      contract.endpoints.each do |endpoint|
        endpoint.methods.each do |method|
          request_def = method.request
          required_fields = request_def.fields.keep_if{|field| field.required}
          combinations = (1..required_fields.size).flat_map{|size| required_fields.combination(size).to_a}
          combinations.each do |remove_fields|
            fields = remove_fields.map{|field| {name: field.name, value: nil}}
            payload = request_def.altered_payload_with fields
            response = endpoint.call base_url: contract.base_url, method: method, payload: payload, headers: request_def.default_headers
            test = RequiredFieldsTest.new response, payload, endpoint.bad_request_response, endpoint.url, method.verb
            reports.concat test.check
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