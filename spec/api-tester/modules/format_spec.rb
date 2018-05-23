require "spec_helper"
require 'webmock/rspec'
require 'api-tester/definition/response'
require 'api-tester/definition/request'
require 'api-tester/definition/endpoint'
require 'api-tester/definition/api_contract'
require 'api-tester/modules/format'
require 'api-tester/reporter/api_report'
require 'api-tester/test_helper'

describe ApiTester::Format do
  let(:url) {"www.example.com"}
  let(:request) { ApiTester::Request.new }
  let(:endpoint) {ApiTester::Endpoint.new "Test", url}
  let(:contract) {ApiTester::ApiContract.new "Test"}
  let(:expected_code) {400}
  let(:expected_response) {ApiTester::Response.new expected_code}
  let(:expected_body) {'{"numKey": 1, "string_key": "string"}'}
  let(:expected_fields) {[ApiTester::Field.new("numKey"), ApiTester::Field.new("string_key")]}
  let(:request_fields) {[ApiTester::ArrayField.new("arr")]}
  let(:report) {ApiTester::ApiReport.new}

  before :each do
    expected_fields.each do |field|
      expected_response.add_field field
    end

    request_fields.each do |field|
      request.add_field field
    end

    endpoint.add_method ApiTester::SupportedVerbs::POST, expected_response, request
    endpoint.bad_request_response = expected_response
    contract.add_endpoint endpoint

    stub_request(:post, url).to_return(body: expected_body, status: expected_code)
  end

  context 'post request' do
    it 'everything works' do
      expect(ApiTester::Format.go(contract).size).to eq 0
    end

    it 'gets a simple string' do
      stub_request(:post, url).to_return(body: 'bad request', status: expected_code)
      expect(ApiTester::Format.go(contract).size).to be >= 1
    end
  end

  context 'should use test helper' do
    before :each do
      test_helper_mock = Class.new(ApiTester::TestHelper) do
        def before
          RestClient.get("www.test.com/before")
        end

        def after
          RestClient.get("www.test.com/after")
        end
      end
      endpoint.test_helper = test_helper_mock.new
      stub_request(:get, "www.test.com/before").to_return(body: '', status: 200)
      stub_request(:get, "www.test.com/after").to_return(body: '', status: 200)
      expect(ApiTester::Format.go(contract).size).to eq 0
    end

    it 'should make use of test helper before method' do
      expect(a_request(:get, "www.test.com/before")).to have_been_made.at_least_once
    end

    it 'should make use of test helper after method' do
      expect(a_request(:get, "www.test.com/after")).to have_been_made.at_least_once
    end
  end
end
