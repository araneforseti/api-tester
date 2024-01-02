# frozen_string_literal: true

require 'api-tester/reporter/status_code_report'
require 'api-tester/util/supported_verbs'

module ApiTester
  # Module checking various not found scenarios
  class MissingResource
    def self.go(contract)
      reports = []

      contract.endpoints.each do |endpoint|
        endpoint.path_params.each do |path_param|
          bad_resource = endpoint.relative_url.gsub("{#{path_param}}", 'gibberish')

          bad_endpoint = ApiTester::Endpoint.new name: 'Bad Resource',
                                                 relative_url: bad_resource
          method = ApiTester::Method.new verb: ApiTester::SupportedVerbs::GET,
                                         response: ApiTester::Response.new(
                                           status_code: 200
                                         ),
                                         request: ApiTester::Request.new
          response = bad_endpoint.call base_url: contract.base_url + bad_resource,
                                       method: method,
                                       payload: {},
                                       headers: contract.required_headers
          test = MissingResourceTest.new response,
                                         {},
                                         endpoint.not_found_response,
                                         bad_resource,
                                         ApiTester::SupportedVerbs::GET
          test.check
        end
      end

      reports
    end

    def self.allowed_verbs(endpoint)
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

  # Test layout for Missing Resource
  class MissingResourceTest < MethodCaseTest
    def initialize(response, payload, expected_response, url, verb)
      super response: response,
            payload: payload,
            expected_response: expected_response,
            url: url,
            verb: verb,
            module_name: 'Missing Resource'
    end
  end
end
