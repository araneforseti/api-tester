# frozen_string_literal: true

require 'api-tester/util/supported_verbs'
require 'api-tester/definition/method'
require 'api-tester/method_case_test'

module ApiTester
  # Check verbs not explicitly defined in contract
  class ExtraVerbs
    def self.go(contract)
      reports = []

      contract.endpoints.each do |endpoint|
        extras = supported_verbs - endpoint.verbs
        headers = endpoint.methods[0].request.default_headers
        extras.each do |verb|
          verb_case = BoundaryCase.new description: "Verb check with #{verb} for #{endpoint.name}",
                                       payload: {},
                                       headers: headers
          method = ApiTester::Method.new verb: verb,
                                         response: ApiTester::Response.new,
                                         request: ApiTester::Request.new
          response = endpoint.call base_url: contract.base_url,
                                   method: method,
                                   payload: verb_case.payload,
                                   headers: verb_case.headers
          test = VerbClass.new response: response,
                               payload: verb_case.payload,
                               expected_response: endpoint.not_allowed_response,
                               url: endpoint.url,
                               verb: verb
          reports.concat test.check
        end
      end

      reports
    end

    def self.supported_verbs
      ApiTester::SupportedVerbs.all
    end

    def self.order
      3
    end
  end

  # Test template used for module
  class VerbClass < MethodCaseTest
    def initialize(response:, payload:, expected_response:, url:, verb:)
      super response: response,
            payload: payload,
            expected_response: expected_response,
            url: url,
            verb: verb,
            module_name: 'VerbModule'
    end
  end
end
