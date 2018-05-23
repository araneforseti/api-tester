require 'api-tester/modules/module'
require 'api-tester/util/supported_verbs'

module ApiTester
  class ExtraVerbs < Module
    def go(endpoint, report)
      super

      extras = ApiTester::SupportedVerbs.all - endpoint.verbs
      extras.each do |verb|
        verb_case = BoundaryCase.new("Verb check with #{verb} for #{endpoint.name}", {}, {})
        method = ApiTester::ApiMethod.new verb, ApiTester::Response.new, ApiTester::Request.new
        response = endpoint.call method, verb_case.payload, verb_case.headers
        test = VerbClass.new response, verb_case.payload, endpoint.not_allowed_response, endpoint.url, verb
        reports = test.check
        self.report.reports.concat reports
      end
      self.report.reports == []
    end
  end

  class VerbClass < MethodCaseTest
      def initialize response, payload, expected_response, url, verb
          super response, payload, expected_response, url, verb, "VerbModule"
      end
  end
end
