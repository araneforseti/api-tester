require "spec_helper"
require 'webmock/rspec'
require 'api-tester/definition/response'
require 'api-tester/definition/request'
require 'api-tester/definition/endpoint'
require 'api-tester/modules/good_case'
require 'api-tester/reporter/api_report'

describe ApiTester::GoodCase do
  context 'get request' do
    let(:url) {"www.example.com"}
    let(:request) { ApiTester::Request.new }
    let(:fields) {[ApiTester::Field.new("numKey"),
                   ApiTester::Field.new("string_key"),
                   ApiTester::ObjectField.new("object_field")
                       .with_field(ApiTester::Field.new "inner_field")
                       .with_field(ApiTester::Field.new("other_field"))]}
    let(:body) { '{"numKey": 1, "string_key": "string", "object_field": {"inner_field": "string", "other_field": "string"}}' }
    let(:code) { 200 }
    let(:endpoint) {ApiTester::Endpoint.new "Test", url}
    let(:response) { ApiTester::Response.new code }
    let(:report) {ApiTester::ApiReport.new}

    before :each do
      fields.each do |field|
        response.add_field field
      end
      endpoint.add_method ApiTester::SupportedVerbs::GET, response, request

      stub_request(:get, "www.example.com").to_return(body: body, status: code)
    end

    context 'status code' do
      it 'can pass compatible status code' do
        expect(ApiTester::GoodCase.go(endpoint).size).to eq 0
      end

      [100, 201, 300, 400, 529].each do | status |
        it "will fail different status code #{status}" do
          response.code = status
          expect(ApiTester::GoodCase.go(endpoint).size).to be >= 1
        end
      end
    end

    context 'body' do
      it 'passes with correct keys' do
        expect(ApiTester::GoodCase.go(endpoint).size).to eq 0
      end

      it 'fails when a key is missing' do
        response.add_field(ApiTester::Field.new("missingField"))
        expect(ApiTester::GoodCase.go(endpoint).size).to be >= 1
      end

      context 'empty response' do
        it 'fails when expecting keys which are not there' do
          stub_request(:get, "www.example.com").to_return(body: '[]', status: code)
          expect(ApiTester::GoodCase.go(endpoint).size).to be >= 1
        end

        it 'passes when expecting an empty body' do
          stub_request(:get, "www.example.com").to_return(body: '[]', status: code)
          response = ApiTester::Response.new 200
          endpoint.methods[0].expected_response = response
          expect(ApiTester::GoodCase.go(endpoint).size).to eq 0
        end
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
        expect(ApiTester::GoodCase.go(endpoint).size).to eq 0
      end

      it 'should make use of test helper before method' do
        expect(a_request(:get, "www.test.com/before")).to have_been_made.at_least_once
      end

      it 'should make use of test helper after method' do
        expect(a_request(:get, "www.test.com/after")).to have_been_made.at_least_once
      end
    end
  end

  context 'post request' do
    let(:url) {"www.example.com"}
    let(:request) { ApiTester::Request.new }
    let(:fields) {[ApiTester::Field.new("numKey"), ApiTester::Field.new("string_key"), ApiTester::ObjectField.new("obj").with_field(ApiTester::Field.new("inner"))]}
    let(:body) { '{"numKey": 1, "string_key": "string", "obj": {"inner": "string"}}' }
    let(:code) { 200 }
    let(:response) { ApiTester::Response.new code }
    let(:endpoint) {ApiTester::Endpoint.new "Test", url}
    let(:report) {ApiTester::ApiReport.new}

    before :each do
      fields.each do |field|
        response.add_field field
      end
      endpoint.add_method ApiTester::SupportedVerbs::POST, response, request
      stub_request(:post, url).to_return(body: body, status: code)
    end

    context 'status code' do
      it 'can pass compatible status code' do
        expect(ApiTester::GoodCase.go(endpoint).size).to eq 0
      end

      [100, 201, 300, 400, 529].each do | status |
        it "will fail different status code #{status}" do
          response.code = status
          expect(ApiTester::GoodCase.go(endpoint).size).to be >= 1
        end
      end
    end

    context 'body' do
      it 'passes with correct keys' do
        expect(ApiTester::GoodCase.go(endpoint).size).to eq 0
      end

      it 'increments keys' do
        ApiTester::GoodCase.go(endpoint)
        expect(fields[0].is_seen).to eq(1)
        expect(fields[1].is_seen).to eq(1)
        expect(fields[2].is_seen).to eq(1)
        expect(fields[2].fields[0].is_seen).to eq(1)
      end

      it 'fails when a key is missing' do
        response.add_field(ApiTester::Field.new("missingField"))
        expect(ApiTester::GoodCase.go(endpoint).size).to be >= 1
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
        expect(ApiTester::GoodCase.go(endpoint).size).to eq 0
      end

      it 'should make use of test helper before method' do
        expect(a_request(:get, "www.test.com/before")).to have_been_made.at_least_once
      end

      it 'should make use of test helper after method' do
        expect(a_request(:get, "www.test.com/after")).to have_been_made.at_least_once
      end
    end
  end
end
