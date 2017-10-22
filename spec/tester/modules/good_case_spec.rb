require "spec_helper"
require 'webmock/rspec'
require 'tester/definition/response'
require 'tester/definition/request'
require 'tester/definition/methods/api_get'
require 'tester/definition/endpoint'
require 'tester/modules/good_case'
require 'tester/reporter/api_report'

describe GoodCase do
  context 'get request' do
    let(:url) {"www.example.com"}
    let(:request) { Request.new }
    let(:fields) {[Field.new("numKey"),
                   Field.new("string_key"),
                   ObjectField.new("object_field")
                       .with_field(Field.new "inner_field")
                       .with_field(Field.new("other_field"))]}
    let(:body) { '{"numKey": 1, "string_key": "string", "object_field": {"inner_field": "string", "other_field": "string"}}' }
    let(:code) { 200 }
    let(:api_get) { ApiGet.new url }
    let(:endpoint) {Endpoint.new "Test"}
    let(:response) { Response.new code }
    let(:good_case) {GoodCase.new}
    let(:report) {ApiReport.new}

    before :each do
      fields.each do |field|
        response.add_field field
      end
      api_get.expected_response = response
      api_get.request = request
      endpoint.add_method api_get

      stub_request(:get, "www.example.com").to_return(body: body, status: code)
    end

    context 'status code' do
      it 'can pass compatible status code' do
        expect(good_case.go(endpoint, report)).to be true
      end

      [100, 201, 300, 400, 529].each do | status |
        it "will fail different status code #{status}" do
          response.code = status
          api_get.expected_response = response
          expect(good_case.go(endpoint, report)).to be false
        end
      end
    end

    context 'body' do
      it 'passes with correct keys' do
        expect(good_case.go(endpoint, report)).to be true
      end

      it 'fails when a key is missing' do
        response.add_field(Field.new("missingField"))
        api_get.expected_response = response
        expect(good_case.go(endpoint, report)).to be false
      end

      context 'empty response' do
        it 'fails when expecting keys which are not there' do
          stub_request(:get, "www.example.com").to_return(body: '[]', status: code)
          expect(good_case.go(endpoint, report)).to be false
        end

        it 'passes when expecting an empty body' do
          stub_request(:get, "www.example.com").to_return(body: '[]', status: code)
          response = Response.new 200
          api_get.expected_response = response
          expect(good_case.go(endpoint, report)).to be true
        end
      end
    end
  end

  context 'post request' do
    let(:url) {"www.example.com"}
    let(:request) { Request.new }
    let(:fields) {[Field.new("numKey"), Field.new("string_key"), ObjectField.new("obj").with_field(Field.new("inner"))]}
    let(:body) { '{"numKey": 1, "string_key": "string", "obj": {"inner": "string"}}' }
    let(:code) { 200 }
    let(:api_post) { ApiPost.new url }
    let(:response) { Response.new code }
    let(:endpoint) {Endpoint.new "Test"}
    let(:good_case) {GoodCase.new}
    let(:report) {ApiReport.new}

    before :each do
      fields.each do |field|
        response.add_field field
      end
      api_post.expected_response = response
      api_post.request = request

      endpoint.add_method api_post

      stub_request(:post, url).to_return(body: body, status: code)
    end

    context 'status code' do
      it 'can pass compatible status code' do
        expect(good_case.go(endpoint, report)).to be true
      end

      [100, 201, 300, 400, 529].each do | status |
        it "will fail different status code #{status}" do
          response.code = status
          api_post.expected_response = response
          expect(good_case.go(endpoint, report)).to be false
        end
      end
    end

    context 'body' do
      it 'passes with correct keys' do
        expect(good_case.go(endpoint, report)).to be true
      end

      it 'increments keys' do
        good_case.go(endpoint, report)
        expect(fields[0].is_seen).to eq(1)
        expect(fields[1].is_seen).to eq(1)
        expect(fields[2].is_seen).to eq(1)
        expect(fields[2].fields[0].is_seen).to eq(1)
      end

      it 'fails when a key is missing' do
        response.add_field(Field.new("missingField"))
        api_post.expected_response = response
        expect(good_case.go(endpoint, report)).to be false
      end
    end
  end
end
