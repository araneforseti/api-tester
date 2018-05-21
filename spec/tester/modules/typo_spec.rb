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
  let(:api_get) { ApiGet.new }
  let(:api_post) { ApiPost.new }
  let(:endpoint) {Endpoint.new "Test", url}
  let(:not_found) {Response.new 404}
  let(:not_allow) {Response.new 415}
  let(:report) {ApiReport.new}

  let(:typo) {Typo.new}

  before :each do
    endpoint.add_method api_get
    endpoint.not_allowed_response = not_allow
    endpoint.not_found_response = not_found

    stub_request(:get, url).to_return(body: "", status: 200)
    stub_request(:post, url).to_return(body: "", status: not_allow.code)
    stub_request(:patch, url).to_return(body: "", status: not_allow.code)
    stub_request(:put, url).to_return(body: "", status: not_allow.code)
    stub_request(:get, bad_url).to_return(body: "", status: not_found.code)
    stub_request(:delete, url).to_return(status: not_allow.code)
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
      api_post = ApiPost.new
      endpoint.add_method api_post
      expected_allowances = {url => [SupportedVerbs::GET, SupportedVerbs::POST]}

      expect(typo.allowances(endpoint)).to eq expected_allowances
    end

    it 'can return the url-method hash' do
      expected_allowances = {url => [SupportedVerbs::GET]}

      expect(typo.allowances(endpoint)).to eq expected_allowances
    end
  end

  context 'should use test helper' do
    before :each do
      test_helper_mock = Class.new(TestHelper) do
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
      expect(typo.go(endpoint, report)).to be true
    end

    it 'should make use of test helper before method' do
      expect(a_request(:get, "www.test.com/before")).to have_been_made.at_least_once
    end

    it 'should make use of test helper after method' do
      expect(a_request(:get, "www.test.com/after")).to have_been_made.at_least_once
    end
  end
end
