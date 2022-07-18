# frozen_string_literal: true

require 'api-tester/util/response_evaluator'

module ApiTester
  # Class for testing methods
  class MethodCaseTest
    attr_accessor :expected_response, :payload, :response, :reports, :url, :module_name

    def initialize(response:, payload:, expected_response:, url:, verb:, module_name:)
      self.payload = payload
      self.response = response
      self.expected_response = expected_response
      self.reports = []
      self.url = "#{verb} #{url}"
      self.module_name = module_name
    end

    def response_code_report
      print 'F'
      report = StatusCodeReport.new description: "#{module_name} - Incorrect response code",
                                    url: url,
                                    request: payload,
                                    expected_status_code: expected_response.code,
                                    actual_status_code: "#{response.code} : #{response.body}"
      reports << report
      nil
    end

    def missing_field_report(field)
      print 'F'
      report = Report.new description: "#{module_name} - Missing field #{field}",
                          url: url,
                          request: payload,
                          expected_response: expected_response,
                          actual_response: response
      reports << report
      nil
    end

    def extra_field_report(field)
      print 'F'
      report = Report.new description: "#{module_name} - Found extra field #{field}",
                          url: url,
                          request: payload,
                          expected_response: expected_response,
                          actual_response: response
      reports << report
      nil
    end

    def check
      if check_response_code
        print '.'
        evaluator = ApiTester::ResponseEvaluator.new actual_body: json_parse(response.body),
                                                     expected_fields: expected_response
        evaluator.missing_fields.map { |field| missing_field_report(field) }
        evaluator.extra_fields.map { |field| extra_field_report(field) }
        increment_fields evaluator.seen_fields
      end
      reports
    end

    def check_response_code
      if response && (response.code != expected_response.code)
        print 'F'
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
