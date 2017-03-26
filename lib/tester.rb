require "tester/version"
require 'rest-client'

module Tester
  def self.get(request, expected_response)
    response = RestClient.get(request.url)
    response.code == expected_response.status_code &&
        response_matches_request(response, expected_response)
  end

  def self.response_matches_request response, expected_response
    fields = expected_response.definition.fields
    fields.each do |field|
      if !field_in_hash(field, response)
        return false
      end
    end
    true
  end

  def self.field_in_hash field, response
    name = field.name
    response.has_key?(name)
  end
end