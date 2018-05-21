require "spec_helper"
require 'webmock/rspec'
require 'tester/definition/response'
require 'tester/definition/methods/api_propfind'

describe ApiPropfind do
  context 'good request' do
    let(:url) {"www.example.com"}
    let(:code) { 200 }
    let(:api_propfind) { ApiPropfind.new }
    let(:response) { Response.new code }

    before :each do
      stub_request(:propfind, "www.example.com").to_return(status: code)
      api_propfind.expected_response = response
    end

    it 'should call' do
      expect(api_propfind.call(url).code).to eq code
    end

  end
end
