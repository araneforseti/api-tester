 require 'api-tester/util/supported_verbs'

module ApiTester
  module ExtraVerbs
    def self.go contract
      reports = []

      contract.endpoints.each do |endpoint|
        extras = ApiTester::SupportedVerbs.all - endpoint.verbs
        headers = endpoint.methods[0].request.default_headers
        extras.each do |verb|
          verb_case = BoundaryCase.new("Verb check with #{verb} for #{endpoint.name}", {}, headers)
          method = ApiTester::Method.new verb, ApiTester::Response.new, ApiTester::Request.new
          response = endpoint.call method: method, payload: verb_case.payload, headers: verb_case.headers
          test = VerbClass.new response, verb_case.payload, endpoint.not_allowed_response, endpoint.url, verb
          reports.concat test.check
        end
      end

      reports
    end

    def self.order
      3
    end
  end

  class VerbClass < MethodCaseTest
      def initialize response, payload, expected_response, url, verb
          super response, payload, expected_response, url, verb, "VerbModule"
      end
  end
end
