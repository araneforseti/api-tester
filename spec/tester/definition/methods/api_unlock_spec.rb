require "spec_helper"
require 'webmock/rspec'
require 'tester/definition/response'
require 'tester/definition/methods/api_unlock'

describe ApiUnlock do
  context 'good request' do
    let(:url) {"www.example.com"}
    let(:code) { 200 }
    let(:api_unlock) { ApiUnlock.new }
    let(:response) { Response.new code }

    before :each do
      stub_request(:unlock, "www.example.com").to_return(status: code)
      api_unlock.expected_response = response
    end

    it 'should call' do
      expect(api_unlock.call(url).code).to eq code
    end

  end
end
