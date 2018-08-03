require 'spec_helper'
require 'webmock/rspec'
require 'api-tester/definition/response'
require 'api-tester/definition/request'
require 'api-tester/definition/endpoint'
require 'api-tester/definition/contract'
require 'api-tester/modules/format'
require 'api-tester/reporter/api_report'
require 'api-tester/test_helper'

describe ApiTester::RequiredFields do
  let(:url) { 'www.example.com' }
  let(:request) { ApiTester::Request.new }
  let(:endpoint) { ApiTester::Endpoint.new name: 'Test', relative_url: '' }
  let(:contract) { ApiTester::Contract.new name: 'Test', base_url: url }
  let(:expected_code) { 400 }
  let(:expected_response) { ApiTester::Response.new status_code: expected_code }
  let(:expected_body) { '{"numKey": 1, "string_key": "string"}' }
  let(:expected_fields) { [ApiTester::Field.new(name: 'numKey'), ApiTester::Field.new(name: 'string_key')] }
  let(:request_fields) { [ApiTester::ArrayField.new(name: 'arr', required: true)] }
  let(:bad_request) { { 'arr' => nil } }
  let(:report) { ApiTester::ApiReport.new }

  before :each do
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

  context 'post request' do
    it 'everything works' do
      puts ApiTester::RequiredFields.go(contract)
      expect(ApiTester::RequiredFields.go(contract).size).to eq 0
    end

    it 'checks case of missing arguments' do
      stub_request(:post, url).with(body: bad_request).to_return(body: 'bad request', status: expected_code)
      expect(ApiTester::RequiredFields.go(contract).size).to be >= 1
    end
  end

  context 'should use test helper' do
    before :each do
      test_helper_mock = Class.new(ApiTester::TestHelper) do
        def before
          RestClient.get('www.test.com/before')
        end

        def after
          RestClient.get('www.test.com/after')
        end
      end
      endpoint.test_helper = test_helper_mock.new
      stub_request(:get, 'www.test.com/before').to_return(body: '', status: 200)
      stub_request(:get, 'www.test.com/after').to_return(body: '', status: 200)
      expect(ApiTester::RequiredFields.go(contract).size).to eq 0
    end

    it 'should make use of test helper before method' do
      expect(a_request(:get, 'www.test.com/before')).to have_been_made.at_least_once
    end

    it 'should make use of test helper after method' do
      expect(a_request(:get, 'www.test.com/after')).to have_been_made.at_least_once
    end
  end
end
