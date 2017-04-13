require "tester/version"
require 'rest-client'
require 'tester/field_checker'
require 'json'

module Tester
  def self.get(request, expected_response)
    response = RestClient.get(request.url)
    response.code == expected_response.status_code &&
        response_matches_request(response, expected_response)
  end

  def self.response_matches_request response, expected_response
    fields = expected_response.definition.fields
    field_checker = FieldChecker.new
    fields.each do |field|
      if !(field_checker.is_field_in_hash(field, JSON.parse(response.body)))
        return false
      end
    end
    true
  end
end