# frozen_string_literal: true

require 'spec_helper'
require 'webmock/rspec'
require 'api-tester/definition/response'
require 'api-tester/definition/request'
require 'api-tester/definition/endpoint'
require 'api-tester/definition/contract'
require 'api-tester/modules/good_case'
require 'api-tester/reporter/api_report'

describe ApiTester::GoodVariations do
  context 'with post request' do
    let(:url) { 'www.example.com' }
    let(:request) {
      ApiTester::Request.new
                        .add_field(ApiTester::EnumField.new(name: 'Test', acceptable_values: [0, 1, 2]))
    }
    let(:fields) {
      [ApiTester::Field.new(name: 'numKey')]
    }
    let(:body) { '{"numKey": 1}' }
    let(:code) { 200 }
    let(:response) { ApiTester::Response.new status_code: code }
    let(:endpoint) { ApiTester::Endpoint.new name: 'Test', relative_url: '' }
    let(:contract) { ApiTester::Contract.new name: 'Test', base_url: url }
    let(:report) { ApiTester::ApiReport.new }

    before do
      fields.each do |field|
        response.add_field field
      end
      endpoint.add_method verb: ApiTester::SupportedVerbs::POST,
                          response: response,
                          request: request
      contract.add_endpoint endpoint

      stub_request(:post, 'http://www.example.com/')
        .with(body: '{"Test":0}')
        .to_return(status: 200, body: body, headers: {})
      stub_request(:post, 'http://www.example.com/')
        .with(body: '{"Test":1}')
        .to_return(status: 200, body: body, headers: {})
      stub_request(:post, 'http://www.example.com/')
        .with(body: '{"Test":2}')
        .to_return(status: 200, body: body, headers: {})
    end

    context 'when request case creation' do
      it 'will check all variations of enum field' do
        described_class.go(contract)

        expect(a_request(:post, 'http://www.example.com')
          .with(body: { Test: 0 }))
          .to have_been_made.once
        expect(a_request(:post, url)
          .with(body: { Test: 1 }))
          .to have_been_made.once
        expect(a_request(:post, url)
          .with(body: { Test: 2 }))
          .to have_been_made.once
      end
    end

    context 'when response parsing' do
      it 'returns true if all response statuses are good' do
        result = described_class.go(contract)

        expect(result).to eq([])
      end

      it 'returns a report if any responses are bad' do
        stub_request(:post, 'http://www.example.com/')
          .with(body: '{"Test":2}')
          .to_return(status: 400, body: '', headers: {})

        result = described_class.go(contract)

        expect(result.size).to eq(1)
      end
    end
  end
end
