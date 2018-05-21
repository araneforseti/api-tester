require "spec_helper"
require 'webmock/rspec'
require 'tester/definition/response'
require 'tester/definition/methods/api_proppatch'

describe ApiProppatch do
  context 'good request' do
    let(:url) {"www.example.com"}
    let(:code) { 200 }
    let(:api_proppatch) { ApiProppatch.new }
    let(:response) { Response.new code }

    before :each do
      stub_request(:proppatch, "www.example.com").to_return(status: code)
      api_proppatch.expected_response = response
    end

    it 'should call' do
      expect(api_proppatch.call(url).code).to eq code
    end

  end
end
