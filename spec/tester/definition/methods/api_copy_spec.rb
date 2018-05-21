require "spec_helper"
require 'webmock/rspec'
require 'tester/definition/response'
require 'tester/definition/methods/api_copy'

describe ApiCopy do
  context 'good request' do
    let(:url) {"www.example.com"}
    let(:code) { 200 }
    let(:api_copy) { ApiCopy.new }
    let(:response) { Response.new code }

    before :each do
      stub_request(:copy, "www.example.com").to_return(status: code)
      api_copy.expected_response = response
    end

    it 'should call' do
      expect(api_copy.call(url).code).to eq code
    end

  end
end
