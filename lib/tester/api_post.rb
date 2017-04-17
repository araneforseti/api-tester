require 'tester/request'
require 'tester/response'
require "tester/version"
require 'rest-client'
require 'json'
require 'tester/util/api_method'
require 'tester/reporter/api_report'
require 'tester/reporter/status_code_report'

class ApiPost < ApiMethod
  attr_accessor :syntax_error_response

  def go
    response = post(url, @request.payload.to_json, @request.headers)
    if response.code != expected_response.status_code
      @report.add_new_report(StatusCodeReport.new("Default payload",
                                                  url,
                                                  @request.payload,
                                                  expected_response.status_code,
                                                  response.code))
      return false
    end

    try_boundary

    response_matches(response)
    super
  end

  def try_boundary
    @request.cases.each do |boundary_request|
      response = post(url, boundary_request.payload, @request.headers)
      if response.code != syntax_error_response.status_code
        @report.add_new_report(StatusCodeReport.new("Boundary tests - #{boundary_request.description}",
                                                    url,
                                                    boundary_request.payload,
                                                    syntax_error_response.status_code,
                                                    response.code))
        return false
      end

      response_matches_expected(response, syntax_error_response)
    end
  end

  def post url, json_payload, headers
    RestClient.post(url, @request.payload.to_json, @request.headers)  {|real_response, request, result| real_response }
  end
end