require 'tester/definition/request'
require 'tester/definition/response'
require "tester/version"
require 'rest-client'
require 'json'
require 'tester/definition//api_method'
require 'tester/reporter/api_report'
require 'tester/reporter/status_code_report'

class ApiPost < ApiMethod
  attr_accessor :syntax_error_response

  def go
    response = post(self.request.payload.to_json, self.request.headers)
    if response.code != expected_response.status_code
      self.report.add_new_report(StatusCodeReport.new("Default payload",
                                                  self.url,
                                                  self.request.payload,
                                                  expected_response.status_code,
                                                  response.code))
      return false
    end

    try_boundary

    response_matches(response)
    super
  end

  def try_boundary
    self.request.cases.each do |boundary_request|
      response = post(boundary_request.payload, self.request.headers)
      if response.code != syntax_error_response.status_code
        self.report.add_new_report(StatusCodeReport.new("Boundary tests - #{boundary_request.description}",
                                                    self.url,
                                                    boundary_request.payload,
                                                    syntax_error_response.status_code,
                                                    response.code))
        return false
      end

      response_matches_expected(response, syntax_error_response)
    end
  end

  def post json_payload, headers
    RestClient.post(self.url, json_payload, headers)  { |real_response, request, result|
      real_response
    }
  end
end