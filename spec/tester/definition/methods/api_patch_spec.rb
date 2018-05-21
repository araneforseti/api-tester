require "spec_helper"
require 'webmock/rspec'
require 'tester/definition/response'
require 'tester/definition/request'
require 'tester/definition/methods/api_patch'

describe ApiPatch do
  context 'good request' do
    let(:url) {"www.example.com"}
    let(:request) { Request.new }
    let(:fields) {[Field.new("numKey"), Field.new("string_key")]}
    let(:body) { '{"numKey": 1, "string_key": "string"}' }
    let(:code) { 200 }
    let(:api_patch) { ApiPatch.new }
    let(:response) { Response.new code }

    before :each do
      fields.each do |field|
        response.add_field field
      end
      api_patch.expected_response = response
      api_patch.request = request

      stub_request(:patch, url).to_return(body: body, status: code)
    end

    it 'should call' do
      expect(api_patch.call(url).code).to eq code
    end
  end
end
