require "spec_helper"
require 'webmock/rspec'
require 'api-tester/definition/response'
require 'api-tester/definition/request'
require 'api-tester/definition/endpoint'
require 'api-tester/modules/typo'
require 'api-tester/reporter/api_report'
require 'api-tester/util/supported_verbs'

describe ApiTester::Typo do
  let(:url) {"www.example.com"}
  let(:bad_url) {"#{url}gibberishadsfasdf"}
  let(:endpoint) {ApiTester::Endpoint.new "Test", url}
  let(:contract) {ApiTester::Contract.new "Test"}
  let(:not_found) {ApiTester::Response.new 404}
  let(:not_allow) {ApiTester::Response.new 415}

  before :each do
    endpoint.add_method ApiTester::SupportedVerbs::GET, ApiTester::Response.new(200)
    endpoint.not_allowed_response = not_allow
    endpoint.not_found_response = not_found
    contract.add_endpoint endpoint

    stub_request(:any, url).to_return(body: "", status: not_allow.code)
    stub_request(:get, url).to_return(body: "", status: 200)
    stub_request(:get, bad_url).to_return(body: "", status: not_found.code)
    stub_request(:delete, url).to_return(status: not_allow.code)
  end

  context 'url does not exist' do
    it 'fails if something other than the expected not found response is returned' do
      stub_request(:get, bad_url).to_return(body: "", status: 100)
      expect(ApiTester::Typo.go(contract).size).to be >= 1
    end

    it 'passes if the expected not found response is returned' do
      stub_request(:get, bad_url).to_return(body: "", status: not_found.code)
      expect(ApiTester::Typo.go(contract).size).to eq 0
    end
  end
end
