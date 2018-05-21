require "spec_helper"
require 'webmock/rspec'
require 'tester/definition/response'
require 'tester/definition/request'
require 'tester/definition/methods/api_put'

describe ApiPut do
  context 'good request' do
    let(:url) {"www.example.com"}
    let(:request) { Request.new }
    let(:fields) {[Field.new("numKey"), Field.new("string_key")]}
    let(:body) { '{"numKey": 1, "string_key": "string"}' }
    let(:code) { 200 }
    let(:api_put) { ApiPut.new }
    let(:response) { Response.new code }

    before :each do
      fields.each do |field|
        response.add_field field
      end
      api_put.expected_response = response
      api_put.request = request

      stub_request(:put, url).to_return(body: body, status: code)
    end

    it 'should call' do
      expect(api_put.call(url).code).to eq code
    end
  end
end
