require 'tester/request'
require 'tester/response'
require 'tester/field_checker'
require 'json'

class ApiMethod
  attr_accessor :request
  attr_accessor :expected_response
  attr_accessor :url

  def initialize url
    @url = url
    @requst = Request.new url
    @response = Response.new 200
  end

  def response_matches response
    fields = expected_response.body
    field_checker = FieldChecker.new
    fields.each do |field|
      if !(field_checker.is_field_in_hash(field, JSON.parse(response.body)))
        return false
      end
    end
    true
  end
end