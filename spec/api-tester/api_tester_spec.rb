require 'spec_helper'
require 'webmock/rspec'
require 'api-tester/definition/response'
require 'api-tester/definition/request'
require 'api-tester/definition/endpoint'
require 'api-tester/definition/contract'
require 'api-tester/modules/good_case'
require 'api-tester/modules/unused_fields'
require 'api-tester/config'

describe ApiTester do
  let(:url) { 'www.example.com' }
  let(:contract) { ApiTester::Contract.new 'Test', url }
  let(:request) { ApiTester::Request.new }
  let(:endpoint) { ApiTester::Endpoint.new 'Test', '' }
  let(:expected_code) { 200 }
  let(:unexpected_code) { 404 }
  let(:not_allowed_code) { 415 }
  let(:expected_response) { ApiTester::Response.new expected_code }
  let(:expected_body) { '{"numKey": 1, "string_key": "string"}' }
  let(:expected_fields) { 
    [ApiTester::Field.new(name: 'numKey'),
     ApiTester::Field.new(name: 'string_key')]
  }
  let(:request_fields) { [ApiTester::ArrayField.new(name: 'arr')] }

  let(:config) {
    ApiTester::Config.new
                     .with_module(ApiTester::ExtraVerbs)
                     .with_module(ApiTester::Format)
                     .with_module(ApiTester::GoodCase)
                     .with_module(ApiTester::Typo)
                     .with_module(ApiTester::UnusedFields)
  }

  before :each do
    expected_fields.each do |field|
      expected_response.add_field field
    end

    request_fields.each do |field|
      request.add_field field
    end

    endpoint.add_method ApiTester::SupportedVerbs::GET,
                        expected_response,
                        request
    endpoint.bad_request_response = expected_response

    contract.add_endpoint endpoint
  end

  context 'no path params' do
    before(:each) do
      stub_request(:any, url).to_return(body: '{}', status: not_allowed_code)
      stub_request(:get, url).to_return(body: expected_body,
                                        status: expected_code)
      stub_request(:get, "#{url}gibberishadsfasdf/").to_return(body: '{}',
                                                               status: unexpected_code)
      stub_request(:get, "#{url}/?arr").to_return(body: expected_body,
                                                  status: expected_code)
    end

    context 'get request' do
      it 'everything works' do
        expect(ApiTester.go(contract, config)).to be true
      end

      it 'field counts are incremented' do
        ApiTester.go(contract, config)
        expected_fields.each do |field|
          expect(field.is_seen).not_to eq 0
        end
      end
    end
  end

  context 'work with path param' do
    let(:path_var) { 'path' }
    let(:path_param) { 'test' }

    before :each do
      endpoint.relative_url = "/{#{path_param}}"
      endpoint.add_path_param path_param
      endpoint.test_helper = PathParamCreator.new path_param, path_var

      endpoint.add_method ApiTester::SupportedVerbs::GET,
                          expected_response,
                          request
      endpoint.bad_request_response = expected_response

      contract.add_endpoint endpoint

      stub_request(:any, "#{url}/#{path_var}").to_return(body: '{}',
                                                         status: not_allowed_code)
      stub_request(:get, "#{url}/#{path_var}").to_return(body: expected_body,
                                                         status: expected_code)
      stub_request(:get, "#{url}/#{path_var}gibberishadsfasdf").to_return(body: '{}', status: unexpected_code)
    end

    it 'everything works' do
      expect(ApiTester.go(contract, config)).to be true
    end
  end
end

class PathParamCreator < ApiTester::TestHelper
  attr_accessor :key
  attr_accessor :value

  def initialize(key, value)
    self.key = key
    self.value = value
  end

  def before; end

  def retrieve_param(key)
    { self.key => value }[key]
  end

  def after; end
end
