# frozen_string_literal: true

require 'api-tester/util/response_evaluator'
require 'api-tester/reporter/status_code_report'
require 'api-tester/example'

module ApiTester
  # Class for testing methods
  class MethodCaseTest
    attr_accessor :expected_response, :payload, :response, :reports, :url, :tester_name

    def initialize(response:, payload:, expected_response:, url:, verb:, module_name:)
      self.payload = payload
      self.response = response
      self.expected_response = expected_response
      self.reports = []
      self.url = "#{verb} #{url}"
      self.tester_name = module_name
    end

    def response_code_report
      print 'F'
      report = ApiTester::StatusCodeReport.new description: "#{module_name} - Incorrect response code",
                                    url: url,
                                    request: payload,
                                    expected_status_code: expected_response.code,
                                    actual_status_code: "#{response.code} : #{response.body}"
      reports << report
      nil
    end

    def missing_field_report(field)
      print 'F'
      report = ApiTester::Report.new description: "#{tester_name} - Missing field #{field}",
                          url: url,
                          request: payload,
                          expected_response: expected_response,
                          actual_response: response
      reports << report
      nil
    end

    def extra_field_report(field)
      print 'F'
      report = ApiTester::Report.new description: "#{tester_name} - Found extra field #{field}",
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

    Result = Struct.new(:status, :message, :pass)
    Exam = Struct.new(:description)

    def check_response_code
      example = Exam.new("#{tester_name} Status code for #{url}")
      result = Result.new(:pass, "Pass", true)
      if(response.code != expected_response.code)
        result = Result.new(:fail, "Expected #{response.code} to equal #{expected_response.code}", false)
      end
      ApiTester.formatter.record(example, result)
      return result.pass
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
