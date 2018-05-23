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
  let(:not_found) {ApiTester::Response.new 404}
  let(:not_allow) {ApiTester::Response.new 415}
  let(:report) {ApiTester::ApiReport.new}

  let(:typo) {ApiTester::Typo.new}

  before :each do
    endpoint.add_method ApiTester::SupportedVerbs::GET, ApiTester::Response.new(200)
    endpoint.not_allowed_response = not_allow
    endpoint.not_found_response = not_found

    stub_request(:any, url).to_return(body: "", status: not_allow.code)
    stub_request(:get, url).to_return(body: "", status: 200)
    stub_request(:get, bad_url).to_return(body: "", status: not_found.code)
    stub_request(:delete, url).to_return(status: not_allow.code)
  end

  context 'url does not exist' do
    it 'fails if something other than the expected not found response is returned' do
      stub_request(:get, bad_url).to_return(body: "", status: 100)
      expect(typo.go(endpoint, report)).to be false
    end

    it 'passes if the expected not found response is returned' do
      stub_request(:get, bad_url).to_return(body: "", status: not_found.code)
      expect(typo.go(endpoint, report)).to be true
    end
  end
end
