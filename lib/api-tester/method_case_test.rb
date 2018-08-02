require 'api-tester/util/response_evaluator.rb'

module ApiTester
  # Class for testing methods
  class MethodCaseTest
    attr_accessor :expected_response
    attr_accessor :payload
    attr_accessor :response
    attr_accessor :reports
    attr_accessor :url
    attr_accessor :module_name

    def initialize(response, payload, expected_response, url, verb, module_name)
      self.payload = payload
      self.response = response
      self.expected_response = expected_response
      self.reports = []
      self.url = "#{verb} #{url}"
      self.module_name = module_name
    end

    def response_code_report
      report = StatusCodeReport.new "#{module_name} - Incorrect response code",
                                    url,
                                    payload,
                                    expected_response.code,
                                    response.code
      reports << report
      nil
    end

    def missing_field_report(field)
      report = Report.new "#{module_name} - Missing field #{field}",
                          url,
                          payload,
                          expected_response,
                          response
      reports << report
      nil
    end

    def extra_field_report(field)
      report = Report.new "#{module_name} - Found extra field #{field}",
                          url,
                          payload,
                          expected_response,
                          response
      reports << report
      nil
    end

    def check
      if check_response_code
        evaluator = ApiTester::ResponseEvaluator.new json_parse(response.body),
                                                     expected_response
        evaluator.missing_fields.map { |field| missing_field_report(field) }
        evaluator.extra_fields.map { |field| extra_field_report(field) }
        increment_fields evaluator.seen_fields
      end
      reports
    end

    def check_response_code
      if response.code != expected_response.code
        response_code_report
        return false
      end
      true
    end

    def increment_fields(seen_fields)
      seen_fields.each(&:seen)
    end

    def json_parse(body)
      JSON.parse!(body)
    rescue JSON::ParserError
      body
    end
  end
end
