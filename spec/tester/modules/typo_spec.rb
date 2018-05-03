require "spec_helper"
require 'webmock/rspec'
require 'tester/definition/response'
require 'tester/definition/request'
require 'tester/definition/methods/api_get'
require 'tester/definition/methods/api_post'
require 'tester/definition/endpoint'
require 'tester/modules/typo'
require 'tester/reporter/api_report'
require 'tester/util/supported_verbs'

describe Typo do
  let(:url) {"www.example.com"}
  let(:bad_url) {"#{url}gibberishadsfasdf"}
  let(:api_get) { ApiGet.new url }
  let(:api_post) { ApiPost.new url }
  let(:endpoint) {Endpoint.new "Test"}
  let(:not_found) {Response.new 404}
  let(:not_allow) {Response.new 415}
  let(:report) {ApiReport.new}

  let(:typo) {Typo.new}

  before :each do
    endpoint.add_method api_get
    endpoint.not_allowed_response = not_allow
    endpoint.not_found_response = not_found

    stub_request(:post, url).to_return(body: "", status: not_allow.code)
    stub_request(:get, url).to_return(body: "", status: 200)
    stub_request(:get, bad_url).to_return(body: "", status: not_found.code)
  end

  context 'verb not defined in definition responds' do
    it 'fails if something other than the expected not allowed response is returned' do
      stub_request(:post, url).to_return(body: "", status: 100)
      expect(typo.go(endpoint, report)).to be false
    end

    it 'passes if the expected not allowed response is returned' do
      stub_request(:post, url).to_return(body: "", status: not_allow.code)
      expect(typo.go(endpoint, report)).to be true
    end
  end

  context 'all verbs defined in definition' do
    it 'passes' do
      endpoint.add_method api_post
      stub_request(:post, url).to_return(body: "", status: 200)
      expect(typo.go(endpoint, report)).to be true
    end
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

  context 'calculate definition allowances' do
    it 'can return the url-method hash' do
      api_post = ApiPost.new url
      api_get_2 = ApiGet.new "new_url"
      endpoint.add_method api_post
      endpoint.add_method api_get_2
      expected_allowances = {url => [SupportedVerbs::GET, SupportedVerbs::POST],
                            "new_url" => [SupportedVerbs::GET]
      }

      expect(typo.allowances(endpoint)).to eq expected_allowances
    end
  end
end
