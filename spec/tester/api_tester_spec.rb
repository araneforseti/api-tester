require "spec_helper"
require 'webmock/rspec'
require 'tester/definition/response'
require 'tester/definition/request'
require 'tester/definition/methods/api_get'
require 'tester/definition/endpoint'
require 'tester/modules/good_case'
require 'tester/modules/unused_fields'
require 'tester/api_tester'
require 'tester/reporter/api_report'

describe ApiTester do
  let(:url) {"www.example.com"}
  let(:api_get) { ApiGet.new url }
  let(:request) { Request.new }
  let(:endpoint) {Endpoint.new "Test"}
  let(:expected_code) {200}
  let(:expected_response) {Response.new expected_code}
  let(:expected_body) {'{"numKey": 1, "string_key": "string"}'}
  let(:expected_fields) {[Field.new("numKey"), Field.new("string_key")]}
  let(:request_fields) {[ArrayField.new("arr")]}
  let(:good_case) {GoodCase.new}
  let(:unused) {UnusedFields.new}
  let(:report) {ApiReport.new}
  let(:api_tester) {ApiTester.new(endpoint)
                        .with_module(unused)
                        .with_module(good_case)
                        .with_reporter(report)}

  before :each do
    expected_fields.each do |field|
      expected_response.add_field field
    end
    api_get.expected_response = expected_response

    request_fields.each do |field|
      request.add_field field
    end
    api_get.request = request

    endpoint.add_method api_get
    endpoint.bad_request_response = expected_response

    stub_request(:get, url).to_return(body: expected_body, status: expected_code)
    stub_request(:get, "#{url}/?arr").to_return(body: expected_body, status: expected_code)
  end

  context 'get request' do
    it 'everything works' do
      expect(api_tester.go).to be true
    end

    it 'field counts are incremented' do
      api_tester.go
      expected_fields.each do |field|
        expect(field.is_seen).not_to eq 0
      end
    end
  end
end