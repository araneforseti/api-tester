require "spec_helper"
require 'webmock/rspec'
require 'tester/definition/response'
require 'tester/definition/request'
require 'tester/definition/endpoint'
require 'tester/definition/api_contract'
require 'tester/modules/good_case'
require 'tester/modules/unused_fields'
require 'tester/api_tester'
require 'tester/reporter/api_report'

describe ApiTester do
  let(:url) {"www.example.com"}
  let(:contract) {ApiContract.new "Test"}
  let(:request) { Request.new }
  let(:endpoint) {Endpoint.new "Test", url}
  let(:path_param) { "test" }
  let(:expected_code) {200}
  let(:unexpected_code) {404}
  let(:not_allowed_code) {415}
  let(:expected_response) {Response.new expected_code}
  let(:expected_body) {'{"numKey": 1, "string_key": "string"}'}
  let(:expected_fields) {[Field.new("numKey"), Field.new("string_key")]}
  let(:request_fields) {[ArrayField.new("arr")]}
  let(:good_case) {GoodCase.new}
  let(:typo) {Typo.new}
  let(:extra_verbs) {ExtraVerbs.new}
  let(:unused) {UnusedFields.new}
  let(:report) {ApiReport.new}
  let(:api_tester) {ApiTester.new(contract)
                        .with_module(unused)
                        .with_module(typo)
                        .with_module(extra_verbs)
                        .with_module(good_case)
                        .with_reporter(report)}

  before :each do
    expected_fields.each do |field|
      expected_response.add_field field
    end

    request_fields.each do |field|
      request.add_field field
    end

    endpoint.add_method SupportedVerbs::GET, expected_response, request
    endpoint.bad_request_response = expected_response

    contract.add_endpoint endpoint

    stub_request(:any, url).to_return(body: "{}", status: not_allowed_code)
    stub_request(:get, url).to_return(body: expected_body, status: expected_code)
    stub_request(:get, "#{url}gibberishadsfasdf/").to_return(body: "{}", status: unexpected_code)
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

  context 'work with path param' do
    before :each do
      path_var = "path"
      endpoint.add_path_param path_param
      endpoint.test_helper = PathParamCreator.new

      endpoint.add_method SupportedVerbs::GET, expected_response, request
      endpoint.bad_request_response = expected_response

      contract.add_endpoint endpoint

      stub_request(:any, "#{url}/#{path_var}").to_return(body: "{}", status: not_allowed_code)
      stub_request(:get, url).to_return(body: expected_body, status: expected_code)
      stub_request(:get, "#{url}gibberishadsfasdf/#{path_var}").to_return(body: "{}", status: unexpected_code)
      stub_request(:get, "#{url}/?arr/#{path_var}").to_return(body: expected_body, status: expected_code)
    end

    it 'everything works' do
      expect(api_tester.go).to be true
    end
  end
end

class PathParamCreator < ApiTester::TestHelper
  def before

  end

  def retrieve_param key
    "path"
  end

  def after

  end
end
