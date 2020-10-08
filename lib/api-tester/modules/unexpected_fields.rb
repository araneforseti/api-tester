# frozen_string_literal: true

require 'pry'

module ApiTester
  # Module checking nothing shows up in response which is not defined in contract
  module UnexpectedFields
    def self.go(contract)
      reports = []

      contract.endpoints.each do |endpoint|
        endpoint.methods.each do |method|
          default_case = BoundaryCase.new description: endpoint.url,
                                          payload: method.request.default_payload,
                                          headers: method.request.default_headers
          response = endpoint.call base_url: contract.base_url,
                                   method: method,
                                   payload: default_case.payload,
                                   headers: default_case.headers
          test = UnexpectedFieldsTest.new response, endpoint.url, method
          reports.concat test.check
        end
      end
      reports
    end

    def self.order
      90
    end
  end

  # Test layout for UnexpectedFields module
  class UnexpectedFieldsTest < MethodCaseTest
    def initialize(response, url, method)
      super response: response,
            payload: method.request.default_payload,
            expected_response: method.expected_response,
            url: url,
            verb: method.verb,
            module_name: 'UnexpectedFieldsModule'
    end

    def check
      evaluator = ApiTester::ResponseEvaluator.new actual_body: json_parse(response.body),
                                                   expected_fields: expected_response
      response_fields = evaluator.response_field_array
      expected_fields = evaluator.expected_fields
      increment_fields evaluator.seen_fields
      extra = response_fields - expected_fields
      extra.each do |extra_field|
        report = Report.new description: "UnexpectedFieldsModule - Found unexpected field #{extra_field}",
                            url: url,
                            request: payload,
                            expected_response: expected_response,
                            actual_response: response
        reports << report
      end
      reports
    end
  end
end
