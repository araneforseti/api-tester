# frozen_string_literal: true

require 'spec_helper'
require 'webmock/rspec'
require 'api-tester/modules/injection_module'
require 'restclient'

describe ApiTester::InjectionModule do
  let(:url) { 'http://www.test.com' }
  let(:expected_response) { "{'error':'bad request'}" }
  let(:good_request) { "{'actual': 'something'}" }
  let(:bad_request) { { 'actual' => 'string%7C' } }
  let(:contract) { ApiTester::Contract.new name: 'Test', base_url: url }
  let(:endpoint) { ApiTester::Endpoint.new name: 'test', relative_url: '' }

  before do
    expected_request = ApiTester::Request.new.add_field(ApiTester::Field.new(name: 'actual'))
    response = ApiTester::Response.new.add_field(ApiTester::Field.new(name: 'actual'))
    endpoint.add_method verb: ApiTester::SupportedVerbs::POST,
                        response: response,
                        request: expected_request
    endpoint.bad_request_response = ApiTester::Response.new status_code: 400
    contract.add_endpoint endpoint

    stub_request(:post, url).to_return(body: good_request, status: 400)
    stub_request(:post, url).with(body: expected_response).to_return(body: good_request, status: 200)
  end

  context 'when go called' do
    it 'does not generate reports if all requests receive right messages' do
      expect(described_class.go(contract).size).to eq 0
    end

    it 'generates report if a request receives appropriate message' do
      stub_request(:post, url).with(body: bad_request).to_return(body: good_request, status: 500)
      expect(described_class.go(contract).size).to be >= 1
    end
  end

  context 'when check_response' do
    let(:response) { instance_double RestClient::Response }

    it 'returns true if response is successful' do
      allow(response).to receive(:code).and_return(200)
      expect(described_class.check_response(response, endpoint)).to be true
    end

    it 'returns true if response is the expected bad format' do
      allow(response).to receive(:code).and_return(400)
      allow(response).to receive(:body) { expected_response }
      expect(described_class.check_response(response, endpoint)).to be true
    end

    it 'returns false if the response is in the wrong format' do
      response_body = { error: 'Nam', badKey: 'a thing' }

      allow(response).to receive(:code).and_return(400)
      allow(response).to receive(:body) { response_body }
      expect(described_class.check_response(response, endpoint)).to be false
    end

    it 'returns false if the response has the wrong code' do
      allow(response).to receive(:code).and_return(500)
      allow(response).to receive(:body) { expected_response }
      expect(described_class.check_response(response, endpoint)).to be false
    end
  end
end
