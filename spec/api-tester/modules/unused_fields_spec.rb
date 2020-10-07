require 'spec_helper'
require 'webmock/rspec'
require 'api-tester/definition/response'
require 'api-tester/definition/request'
require 'api-tester/definition/contract'
require 'api-tester/definition/endpoint'
require 'api-tester/modules/unused_fields'
require 'api-tester/reporter/api_report'

describe ApiTester::UnusedFields do
  context 'post request' do
    let(:url) { 'www.example.com' }
    let(:request) { ApiTester::Request.new }
    let(:fields) {
      [ApiTester::Field.new(name: 'numKey'),
       ApiTester::Field.new(name: 'string_key')]
    }
    let(:body) { '{"numKey": 1, "string_key": "string"}' }
    let(:code) { 200 }
    let(:response) { ApiTester::Response.new status_code: code }
    let(:endpoint) { ApiTester::Endpoint.new name: 'Test', relative_url: '' }
    let(:contract) { ApiTester::Contract.new name: 'Test', base_url: url }

    before :each do
      fields.each do |field|
        response.add_field field
      end
      endpoint.add_method verb: ApiTester::SupportedVerbs::POST,
                          response: response,
                          request: request
      contract.add_endpoint endpoint
    end

    context 'no fields marked' do
      it 'fails' do
        expect(ApiTester::UnusedFields.go(contract).size).to be >= 1
      end

      it 'adds no reports' do
        expect(ApiTester::UnusedFields.go(contract).size).to eq fields.size
      end
    end

    context 'all fields marked' do
      before :each do
        fields.map(&:seen)
      end

      it 'passes' do
        expect(ApiTester::UnusedFields.go(contract).size).to eq 0
      end

      it 'does not add to report' do
        expect(ApiTester::UnusedFields.go(contract).size).to be 0
      end
    end

    context 'only one field marked' do
      before :each do
        marked_field = ApiTester::Field.new name: 'testField'
        marked_field.seen
        response.add_field marked_field
      end

      it 'fails' do
        expect(ApiTester::UnusedFields.go(contract).size).to be >= 1
      end

      it 'adds no reports' do
        expect(ApiTester::UnusedFields.go(contract).size).to eq fields.size
      end
    end
  end
end
