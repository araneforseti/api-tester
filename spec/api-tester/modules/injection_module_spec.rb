require "spec_helper"
require 'webmock/rspec'
require "api-tester/modules/injection_module"

describe ApiTester::InjectionModule do
  let(:url) {"http://www.test.com"}
  let(:expected_response) {'{"error":"bad request"}'}
  let(:good_request) { '{"actual": "something"}' }
  let(:bad_request) { {"actual"=>"string%7C"} }
  let(:contract) {ApiTester::Contract.new "Test"}
  let(:endpoint) {ApiTester::Endpoint.new "test", url}

  before :each do
    expected_request = ApiTester::Request.new().add_field(ApiTester::Field.new "actual")
    response = ApiTester::Response.new().add_field(ApiTester::Field.new "actual")
    endpoint.add_method ApiTester::SupportedVerbs::POST, response, expected_request
    endpoint.bad_request_response = ApiTester::Response.new 400
    contract.add_endpoint endpoint

    stub_request(:post, url).to_return(body: good_request, status: 400)
    stub_request(:post, url).with(body: expected_response).to_return(body: good_request, status: 200)
  end

  context 'go' do
    it 'should not generate reports if all requests receive appropriate message' do
      expect(ApiTester::InjectionModule.go(contract).size).to eq 0
    end

    it 'should generate report if a request receives appropriate message' do
      stub_request(:post, url).with(body: bad_request).to_return(body: good_request, status: 500)
      expect(ApiTester::InjectionModule.go(contract).size).to be >= 1
    end
  end

  context 'check_response' do
    let(:response_body) { {"error": "Nam", "badKey": "a thing"} }
    let(:response) { instance_double "Response "}

    it 'should return true if response is successful' do
      allow(response).to receive(:code) { 200 }
      expect(ApiTester::InjectionModule.check_response(response, endpoint)).to be true
    end

    it 'should return true if response is the expected bad format' do
      allow(response).to receive(:code) { 400 }
      allow(response).to receive(:body) { expected_response }
      expect(ApiTester::InjectionModule.check_response(response, endpoint)).to be true
    end

    it 'should return false if the response is in the wrong format' do
      allow(response).to receive(:code) { 400 }
      allow(response).to receive(:body) { response_body }
      expect(ApiTester::InjectionModule.check_response(response, endpoint)).to be false
    end

    it 'should return false if the response has the wrong code' do
      allow(response).to receive(:code) { 500 }
      allow(response).to receive(:body) { expected_response }
      expect(ApiTester::InjectionModule.check_response(response, endpoint)).to be false
    end
  end
end
