require 'api-tester/reporter/status_code_report'
require 'api-tester/util/supported_verbs'

module ApiTester
  # Module checking various not found scenarios
  module Typo
    def self.go(contract)
      reports = []

      contract.endpoints.each do |endpoint|
        allowances(endpoint).each do
          reports.concat check_typo_url(contract.base_url, endpoint)
        end
      end

      reports
    end

    def self.check_typo_url(base_url, endpoint)
      bad_url = "#{endpoint.url}gibberishadsfasdf"
      bad_endpoint = ApiTester::Endpoint.new 'Bad URL', bad_url
      typo_case = BoundaryCase.new description: 'Typo URL check', 
                                   payload: {}, 
                                   headers: {}
      method = ApiTester::Method.new(ApiTester::SupportedVerbs::GET,
                                     ApiTester::Response.new(200),
                                     ApiTester::Request.new)
      response = bad_endpoint.call base_url: base_url,
                                   method: method,
                                   payload: typo_case.payload,
                                   headers: typo_case.headers

      test = TypoClass.new response,
                           typo_case.payload,
                           endpoint.not_found_response,
                           bad_url,
                           ApiTester::SupportedVerbs::GET
      test.check
    end

    def self.allowances(endpoint)
      allowances = []
      endpoint.methods.each do |method|
        allowances << method.verb
      end
      allowances.uniq
    end

    def self.order
      4
    end
  end

  # Test layout for TypoModule
  class TypoClass < MethodCaseTest
    def initialize(response, payload, expected_response, url, verb)
      super response, payload, expected_response, url, verb, 'TypoModule'
    end
  end
end
