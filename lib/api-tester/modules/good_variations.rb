# frozen_string_literal: true

require 'api-tester/reporter/status_code_report'
require 'api-tester/method_case_test'

module ApiTester
  # Checks the good case as defined in contract
  module GoodVariations
    def self.go(contract)
      reports = []

      contract.endpoints.each do |endpoint|
        endpoint.methods.each do |method|
          method.request.fields.each do |field|
            field.good_cases.each do |value|
              payload = method.request.default_payload
              payload[field.name] = value
              call = BoundaryCase.new description: contract.base_url + endpoint.display_url,
                payload: payload,
                headers: method.request.default_headers
              response = endpoint.call base_url: contract.base_url,
                method: method,
                payload: payload,
                headers: call.headers
              test = GoodVariationTest.new response: response,
                url: contract.base_url + endpoint.url,
                method: method
              reports.concat test.check
            end
          end
          method.request.query_params.each do |field|
            field.good_cases.each do |value|
              payload = method.request.default_payload
              payload[field.name] = value
              call = BoundaryCase.new description: contract.base_url + endpoint.display_url,
                payload: payload,
                headers: method.request.default_headers
              response = endpoint.call base_url: contract.base_url,
                method: method,
                payload: payload,
                headers: call.headers
              test = GoodVariationTest.new response: response,
                url: contract.base_url + endpoint.url,
                method: method
              reports.concat test.check
            end
          end
        end
      end
      reports
    end

    def self.order
      1
    end
  end

  # Test layout used by module
  class GoodVariationTest < MethodCaseTest
    def initialize(response:, url:, method:)
      super response: response,
            payload: method.request.default_payload,
            expected_response: method.expected_response,
            url: url,
            verb: method.verb,
            module_name: 'GoodVariationsModule'
    end
  end
end
