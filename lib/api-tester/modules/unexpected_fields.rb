module ApiTester
  module UnexpectedFields
    def self.go contract
      reports = []

      contract.endpoints.each do |endpoint|
        endpoint.methods.each do |method|
          default_case = BoundaryCase.new endpoint.url, method.request.default_payload, method.request.default_headers
          response = endpoint.call base_url: contract.base_url, method: method, payload: default_case.payload, headers: default_case.headers
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

  class UnexpectedFieldsTest < MethodCaseTest
    def initialize response, url, method
      super response, method.request.default_payload, method.expected_response, url, method.verb, "UnexpectedFieldsModule"
    end

    def check
      evaluator = ApiTester::ResponseEvaluator.new json_parse(self.response.body), self.expected_response
      response_fields = evaluator.response_field_array
      expected_fields = evaluator.expected_fields
      increment_fields evaluator.seen_fields
      extra = response_fields - expected_fields
      extra.each do |extra_field|
        self.reports << Report.new("UnexpectedFieldsModule - Found unexpected field #{extra_field}", self.url, self.payload, self.expected_response, self.response)
      end
      self.reports
    end
  end
end