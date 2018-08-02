require 'spec_helper'
require 'webmock/rspec'
require 'api-tester/definition/response'
require 'api-tester/definition/request'
require 'api-tester/definition/endpoint'
require 'api-tester/definition/contract'
require 'api-tester/modules/unexpected_fields'
require 'api-tester/reporter/api_report'

describe ApiTester::UnexpectedFields do
  context 'get request' do
    let(:url) { 'www.example.com' }
    let(:request) { ApiTester::Request.new }
    let(:fields) { [ApiTester::Field.new(name: 'numKey'),
                    ApiTester::Field.new(name: 'string_key'),
                    ApiTester::ObjectField.new(name: 'object_field')
                       .with_field(ApiTester::Field.new name: 'inner_field')
                       .with_field(ApiTester::Field.new name: 'other_field')] }
    let(:body) { "{'numKey': 1, 'string_key': 'string', 'object_field': {'inner_field': 'string', 'other_field': 'string'}}" }
    let(:code) { 200 }
    let(:endpoint) { ApiTester::Endpoint.new 'Test', '' }
    let(:contract) { ApiTester::Contract.new 'Test', url }
    let(:response) { ApiTester::Response.new code }
    let(:report) { ApiTester::ApiReport.new }

    before :each do
      fields.each do |field|
        response.add_field field
      end
      endpoint.add_method ApiTester::SupportedVerbs::GET, response, request
      contract.add_endpoint endpoint

      stub_request(:get, 'www.example.com').to_return(body: body, status: code)
    end

    context 'body' do
      it 'passes with correct keys' do
        expect(ApiTester::UnexpectedFields.go(contract).size).to eq 0
      end

      it 'fails when an extra key is present' do
        body = '{"extra": 0, "numKey": 1, "string_key": "string", "object_field": {"inner_field": "string", "other_field": "string"}}' 
        stub_request(:get, 'www.example.com').to_return(body: body, status: code)
        expect(ApiTester::UnexpectedFields.go(contract).size).to be >= 1
      end

      context 'empty response' do
        it 'passes' do
          stub_request(:get, 'www.example.com').to_return(body: '[]', status: code)
          expect(ApiTester::UnexpectedFields.go(contract).size).to eq 0
        end

        it 'passes when expecting an empty body' do
          stub_request(:get, 'www.example.com').to_return(body: '[]', status: code)
          response = ApiTester::Response.new 200
          endpoint.methods[0].expected_response = response
          expect(ApiTester::UnexpectedFields.go(contract).size).to eq 0
        end
      end
    end

    context 'should use test helper' do
      before :each do
        test_helper_mock = Class.new(ApiTester::TestHelper) do
          def before
            RestClient.get('www.test.com/before')
          end

          def after
            RestClient.get('www.test.com/after')
          end
        end
        endpoint.test_helper = test_helper_mock.new
        stub_request(:get, 'www.test.com/before').to_return(body: '', status: 200)
        stub_request(:get, 'www.test.com/after').to_return(body: '', status: 200)
        expect(ApiTester::UnexpectedFields.go(contract).size).to eq 0
      end

      it 'should make use of test helper before method' do
        expect(a_request(:get, 'www.test.com/before')).to have_been_made.at_least_once
      end

      it 'should make use of test helper after method' do
        expect(a_request(:get, 'www.test.com/after')).to have_been_made.at_least_once
      end
    end
  end
end
