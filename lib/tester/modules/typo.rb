require 'tester/reporter/status_code_report'
require 'tester/modules/module'
require 'tester/util/supported_verbs'

class Typo < Module
    def go(definition, report)
        super

        contract = allowances(definition)

        contract.each do |url, verbs|
            check_verbs definition, url, verbs

            check_typo_url definition, url
        end

        report.reports == []
    end

    def check_verbs definition, url, verbs
        missing_verbs = SupportedVerbs.all - verbs
        missing_verbs.each do |verb|
            check_method = create_api_method verb
            typo_case = BoundaryCase.new("Typo verb check #{verb}", {}, {})
            response = self.call check_method, definition, typo_case

            test = TypoClass.new response, typo_case.payload, definition.not_allowed_response, url, verb
            reports = test.check
            self.report.reports.concat reports
        end
    end

    def check_typo_url definition, url
        bad_url = "#{url}gibberishadsfasdf"
        bad_definition = Endpoint.new "Bad URL", bad_url
        typo_case = BoundaryCase.new("Typo URL check", {}, {})
        check_method = create_api_method SupportedVerbs::GET
        response = self.call check_method, bad_definition, typo_case

        test = TypoClass.new response, typo_case.payload, definition.not_found_response, bad_url, SupportedVerbs::GET
            reports = test.check
        self.report.reports.concat reports
    end

    def create_api_method verb
      method = SupportedVerbs.get_method_for(verb)
      puts verb
      puts "Found: "
      puts method
      method.new
    end

    def allowances(definition)
        allowances = {}
        definition.methods.each do |method|
            url = definition.url
            if allowances[url]
                allowances[url] << method.verb
            else
                allowances[url] = [method.verb]
            end
        end
        allowances
    end
end

class TypoClass < MethodCaseTest
    def initialize response, payload, expected_response, url, verb
        super response, payload, expected_response, url, verb, "TypoModule"
    end
end
