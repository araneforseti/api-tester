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
        puts "Missing verbs: #{missing_verbs}"
        missing_verbs.each do |verb|
            response = call url, verb
            request = Request.new

            test = TypoClass.new response, request.payload, definition.not_allowed_response, url, verb
            reports = test.check
            puts "Verb check found #{reports.size}"
            puts reports
            puts "****"
            self.report.reports.concat reports
        end
    end

    def check_typo_url definition, url
        bad_url = "#{url}gibberishadsfasdf"
        request = Request.new
        response = call bad_url, SupportedVerbs::GET

        test = TypoClass.new response, request.payload, definition.not_found_response, bad_url, SupportedVerbs::GET
            reports = test.check
            puts "Mistype url check found #{reports.size}"
            puts reports
            puts "****"
        self.report.reports.concat reports
    end

    def allowances(definition)
        allowances = {}
        definition.methods.each do |method|
            url = method.url
            if allowances[url]
                allowances[url] << method.verb
            else
                allowances[url] = [method.verb]
            end
        end
        allowances
    end

    def call(url, verb)
        begin
            RestClient::Request.execute(method: verb, url: url,
                                timeout: 10)
        rescue RestClient::ExceptionWithResponse => e
            e.response
        end
    end
end

class TypoClass < MethodCaseTest
    def initialize response, payload, expected_response, url, verb
        super response, payload, expected_response, url, verb, "TypoModule"
    end
end
