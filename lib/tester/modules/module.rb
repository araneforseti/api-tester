require 'tester/reporter/status_code_report'

class Module
  attr_accessor :report

  def set_report report
    self.report = report
  end

  def go definition, report
    set_report report
  end

  def response_matches response, request, expected_response, method
    if response.code == expected_response.code
      check_response response, expected_response, request, method
    else
      incorrect_status_report response.code, expected_response.code, request, "Incorrect status", method
    end
  end

  def incorrect_status_report status, expected_status, request, message, method
    report = StatusCodeReport.new message, method.url, request, expected_status, status
    self.report.add_new_report report
  end

  def missing_field_report description, request_body, missing_field, url
    report = MissingFieldReport.new description, url, request_body, missing_field
    self.report.add_new_report report
  end

  def check_response response, expected_response, request, method
    response_matches_expected response, expected_response, method.url, request
  end

  def response_matches_expected response, intended_response, url, request
    fields = intended_response.body
    response_body = JSON.parse(response.body)
    fields.each do |field|
      if !(is_field_in_hash(field, response_body, url, request))
        missing_field_report("Default payload field check missing #{field.name}", request, field.name, url)
      end

      if field.has_subfields?
        check_based_on_type(field, response_body, url, request)
      end
    end
  end

  def is_field_in_hash field, hash, url, request
    if hash.empty? || hash.class.to_s != "Hash"
      return false
    end

    if hash.has_key?(field.name)
      if !field.has_subfields?
        return true
      end

      if field.has_subfields?
        if !check_based_on_type(field, hash, url, request)
          return false
        end
      end
      return true
    end
    false
  end

  def check_object_subfields field, field_hash, url, request
    field.fields.each do |subfield|
      if field_hash.empty? || !is_in_hash(subfield, field_hash[field.name])
        missing_field_report("Default payload field check missing #{field.name}", request, subfield.name, url)
      end
    end
    true
  end

  def check_array_subfields field, field_hash, url, request
    field.fields.each do |subfield|
      if field_hash.empty? || !is_in_hash(subfield, field_hash[field.name][0])
        missing_field_report("Default payload field check missing #{field.name}", request, subfield.name, url)
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

  def check_based_on_type field, field_hash, url, request
    field.is_a?(ObjectField) ? check_object_subfields(field, field_hash, url, request) : check_array_subfields(field, field_hash, url, request)
  end
end