require 'tester/request'
require 'tester/response'
require 'tester/reporter/status_code_report'
require 'tester/reporter/missing_field_report'
require 'json'

class ApiMethod
  attr_accessor :request
  attr_accessor :expected_response
  attr_accessor :url

  def initialize url
    @url = url
    @requst = Request.new url
    @response = Response.new 200
    @report = ApiReport.new
  end

  def go
    @report.print
    @report.reports.size == 0
  end

  def missing_field_report description, url, request_body, missing_field
    report = MissingFieldReport.new description, url, request_body, missing_field
    @report.add_new_report report
  end

  def response_matches response
    fields = expected_response.body
    response_body = JSON.parse(response.body)
    fields.each do |field|
      if !(is_field_in_hash(field, response_body))
        missing_field_report("Default payload field check missing #{field.name}", @requst.url, @requst.payload, field.name)
      end

      if field.has_subfields?
        check_based_on_type(field, response_body)
      end
    end
  end

  def is_field_in_hash field, hash
    if hash.empty? || hash.class.to_s != "Hash"
      return false
    end

    if hash.has_key?(field.name)
      if !field.has_subfields?
        return true
      end

      if field.has_subfields?
        if !check_based_on_type(field, hash)
          return false
        end
      end
      return true
    end
    false
  end

  def check_object_subfields field, field_hash
    field.fields.each do |subfield|
      if field_hash.empty? || !is_in_hash(subfield, field_hash[field.name])
        return false
      end
    end
    true
  end

  def check_array_subfields field, field_hash
    field.fields.each do |subfield|
      if field_hash.empty? || !is_in_hash(subfield, field_hash[field.name][0])
        missing_field_report("Default payload field check missing #{field.name}", @requst.url, @requst.payload, subfield.name)
      end
    end
    true
  end

  def is_in_hash(field, field_hash)
    if field_hash.class.to_s != "Hash" || field_hash.empty?
      return false
    end

    if field_hash.has_key?(field.name)
      if !field.has_subfields?
        return true
      else
        return true
      end
    end
    false
  end

  def check_based_on_type field, field_hash
    field.is_a?(ObjectField) ? check_object_subfields(field, field_hash) : check_array_subfields(field, field_hash)
  end
end