require 'api-tester/reporter/status_code_report'
require 'api-tester/modules/module'
require 'api-tester/util/supported_verbs'

module ApiTester
  class Typo < Module
      def go(endpoint, report)
          super

          allowances(endpoint).each do |verbs|
              check_typo_url endpoint
          end

          report.reports == []
      end

      def check_typo_url endpoint
          bad_url = "#{endpoint.url}gibberishadsfasdf"
          bad_endpoint = ApiTester::Endpoint.new "Bad URL", bad_url
          typo_case = BoundaryCase.new("Typo URL check", {}, {})
          method = ApiTester::ApiMethod.new ApiTester::SupportedVerbs::GET, ApiTester::Response.new(200), ApiTester::Request.new
          response = bad_endpoint.call method, typo_case.payload, typo_case.headers

          test = TypoClass.new response, typo_case.payload, endpoint.not_found_response, bad_url, ApiTester::SupportedVerbs::GET
              reports = test.check
          self.report.reports.concat reports
      end

      def allowances(endpoint)
          allowances = []
          endpoint.methods.each do |method|
              allowances << method.verb
          end
          allowances.uniq
      end
  end

  class TypoClass < MethodCaseTest
      def initialize response, payload, expected_response, url, verb
          super response, payload, expected_response, url, verb, "TypoModule"
      end
  end
end
