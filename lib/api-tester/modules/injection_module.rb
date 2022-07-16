# frozen_string_literal: true

require 'injection_vulnerability_library'

module ApiTester
  # Tests injection cases
  module InjectionModule
    def self.go(contract)
      reports = []
      contract.endpoints.each do |endpoint|
        endpoint.methods.each do |method|
          reports.concat inject_payload contract.base_url, endpoint, method
        end
      end
      reports
    end

    def self.inject_payload(base_url, endpoint, method)
      reports = []
      sql_injections = InjectionVulnerabilityLibrary.sql_vulnerabilities

      method.request.fields.each do |field|
        sql_injections.each do |injection|
          injection_value = "#{field.default}#{injection}"
          payload = method.request.altered_payload field_name: field.name,
                                                   value: injection_value
          response = endpoint.call base_url: base_url,
                                   method: method,
                                   payload: payload,
                                   headers: method.request.default_headers
          next if check_response(response, endpoint)

          reports << InjectionReport.new('sql',
                                         endpoint.url,
                                         payload,
                                         response)
        end
      end

      reports
    end

    def self.check_response(response, endpoint)
      if(response.code == 200 || check_error(response, endpoint))
        print "."
        return true
      end
      print "F"
      return false
    end

    def self.check_error(response, endpoint)
      evaluator = ApiTester::ResponseEvaluator.new(
        actual_body: response.body,
        expected_fields: endpoint.bad_request_response
      )
      missing_fields = evaluator.missing_fields
      extra_fields = evaluator.extra_fields
      response.code == endpoint.bad_request_response.code &&
        missing_fields.size.zero? && extra_fields.size.zero?
    end
  end
  
  def self.order
    5
  end
end

# Report for InjectionModule
class InjectionReport
  attr_accessor :injection_type, :url, :payload, :response

  def initialize(injection_type, url, payload, response)
    self.injection_type = injection_type
    self.url = url
    self.payload = payload
    self.response = response
  end

  def print
    puts "Found potential #{injection_type}: "
    puts "   Requested #{url} with payload:"
    puts "      #{payload}"
    puts '   Received: '
    puts "      #{response}"
  end
end
