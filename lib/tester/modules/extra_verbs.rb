require 'tester/modules/module'
require 'tester/util/supported_verbs'

class ExtraVerbs < Module
  def go(endpoint, report)
    super

    extras = SupportedVerbs.all - endpoint.verbs
    extras.each do |verb|
      verb_case = BoundaryCase.new("Verb check with #{verb} for #{endpoint.name}", {}, {})
      method = ApiMethod.new verb, Response.new, Request.new
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
