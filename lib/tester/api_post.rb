require 'tester/request'
require 'tester/response'
require "tester/version"
require 'rest-client'
require 'json'
require 'tester/util/api_method'
require 'tester/reporter/api_report'
require 'tester/reporter/status_code_report'

class ApiPost < ApiMethod
  def go
    response = RestClient.post(url, @request.payload.to_json, @request.headers)
    if response.code != expected_response.status_code
      puts "Got #{response.code} when expecting #{expected_response.status_code}"
      @report.add_new_report(StatusCodeReport.new("Default payload",
                                                  url,
                                                  @request.payload,
                                                  expected_response.status_code,
                                                  response.code))
      return false
    end

    response_matches(response)
  end
end