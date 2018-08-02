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
      super response,
            method.request.default_payload,
            method.expected_response,
            url,
            method.verb,
            'UnexpectedFieldsModule'
    end

    def check
      evaluator = ApiTester::ResponseEvaluator.new json_parse(response.body),
                                                   expected_response
      response_fields = evaluator.response_field_array
      expected_fields = evaluator.expected_fields
      increment_fields evaluator.seen_fields
      extra = response_fields - expected_fields
      extra.each do |extra_field|
        reports << Report.new("UnexpectedFieldsModule - Found unexpected field #{extra_field}", url, payload, expected_response, response)
      end
      reports
    end
  end
end
