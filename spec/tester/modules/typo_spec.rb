require "spec_helper"
require 'webmock/rspec'
require 'tester/definition/response'
require 'tester/definition/request'
require 'tester/definition/endpoint'
require 'tester/modules/typo'
require 'tester/reporter/api_report'
require 'tester/util/supported_verbs'

describe Typo do
  let(:url) {"www.example.com"}
  let(:bad_url) {"#{url}gibberishadsfasdf"}
  let(:endpoint) {Endpoint.new "Test", url}
  let(:not_found) {Response.new 404}
  let(:not_allow) {Response.new 415}
  let(:report) {ApiReport.new}

  let(:typo) {Typo.new}

  before :each do
    endpoint.add_method SupportedVerbs::GET, Response.new(200)
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
