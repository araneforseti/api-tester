# frozen_string_literal: true

require 'spec_helper'
require 'webmock/rspec'
require 'api-tester/definition/response'
require 'api-tester/definition/request'
require 'api-tester/definition/endpoint'
require 'api-tester/definition/contract'
require 'api-tester/modules/format'
require 'api-tester/reporter/api_report'
require 'api-tester/test_helper'

describe ApiTester::Format do
  let(:url) { 'www.example.com' }
  let(:request) { ApiTester::Request.new }
  let(:endpoint) { ApiTester::Endpoint.new name: 'Test', relative_url: '' }
  let(:contract) { ApiTester::Contract.new name: 'Test', base_url: url }
  let(:expected_code) { 400 }
  let(:expected_response) { ApiTester::Response.new status_code: expected_code }
  let(:expected_body) { '{"numKey": 1, "string_key": "string"}' }
  let(:expected_fields) {
    [ApiTester::Field.new(name: 'numKey'),
     ApiTester::Field.new(name: 'string_key')]
  }
  let(:request_fields) { [ApiTester::ArrayField.new(name: 'arr')] }
  let(:report) { ApiTester::ApiReport.new }

  before do
    expected_fields.each do |field|
      expected_response.add_field field
    end

    request_fields.each do |field|
      request.add_field field
    end

    endpoint.add_method verb: ApiTester::SupportedVerbs::POST,
                        response: expected_response,
                        request: request
    endpoint.bad_request_response = expected_response
    contract.add_endpoint endpoint

    stub_request(:post, url).to_return(body: expected_body,
                                       status: expected_code)
  end

  context 'when post request' do
    it 'everything works' do
      expect(described_class.go(contract).size).to eq 0
    end

    it 'gets a simple string' do
      stub_request(:post, url).to_return(body: 'bad request',
                                         status: expected_code)
      expect(described_class.go(contract).size).to be >= 1
    end
  end

  context 'with test helper' do
    before do
      endpoint.test_helper = test_helper_mock.new
      stub_request(:get, 'www.test.com/before').to_return(body: '', status: 200)
      stub_request(:get, 'www.test.com/after').to_return(body: '', status: 200)
      described_class.go(contract)
    end

    it 'makes use of test helper before method' do
      expect(a_request(:get, 'www.test.com/before')).to have_been_made.at_least_once
    end

    it 'makes use of test helper after method' do
      expect(a_request(:get, 'www.test.com/after')).to have_been_made.at_least_once
    end
  end
end
