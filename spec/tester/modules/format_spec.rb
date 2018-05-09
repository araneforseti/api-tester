require "spec_helper"
require 'webmock/rspec'
require 'tester/definition/response'
require 'tester/definition/request'
require 'tester/definition/methods/api_get'
require 'tester/definition/endpoint'
require 'tester/modules/format'
require 'tester/reporter/api_report'
require 'tester/test_helper'

describe Format do
  let(:url) {"www.example.com"}
  let(:api_post) { ApiPost.new }
  let(:request) { Request.new }
  let(:endpoint) {Endpoint.new "Test", url}
  let(:expected_code) {400}
  let(:expected_response) {Response.new expected_code}
  let(:expected_body) {'{"numKey": 1, "string_key": "string"}'}
  let(:expected_fields) {[Field.new("numKey"), Field.new("string_key")]}
  let(:request_fields) {[ArrayField.new("arr")]}
  let(:format) {Format.new}
  let(:report) {ApiReport.new}

  before :each do
    expected_fields.each do |field|
      expected_response.add_field field
    end
    api_post.expected_response = expected_response

    request_fields.each do |field|
      request.add_field field
    end
    api_post.request = request

    endpoint.add_method api_post
    endpoint.bad_request_response = expected_response

    stub_request(:post, url).to_return(body: expected_body, status: expected_code)
  end

  context 'post request' do
    it 'everything works' do
      expect(format.go(endpoint, report)).to be true
    end

    it 'gets a simple string' do
      stub_request(:post, url).to_return(body: 'bad request', status: expected_code)
      expect(format.go(endpoint, report)).to be false
    end
  end

  context 'should use test helper' do
    before :each do
      test_helper_mock = Class.new(TestHelper) do
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
      expect(format.go(endpoint, report)).to be true
    end

    it 'should make use of test helper before method' do
      expect(a_request(:get, "www.test.com/before")).to have_been_made.at_least_once
    end

    it 'should make use of test helper after method' do
      expect(a_request(:get, "www.test.com/after")).to have_been_made.at_least_once
    end
  end
end
