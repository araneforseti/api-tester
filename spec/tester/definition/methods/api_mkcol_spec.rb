require "spec_helper"
require 'webmock/rspec'
require 'tester/definition/response'
require 'tester/definition/methods/api_mkcol'

describe ApiMkcol do
  context 'good request' do
    let(:url) {"www.example.com"}
    let(:code) { 200 }
    let(:api_mkcol) { ApiMkcol.new }
    let(:response) { Response.new code }

    before :each do
      stub_request(:mkcol, "www.example.com").to_return(status: code)
      api_mkcol.expected_response = response
    end

    it 'should call' do
      expect(api_mkcol.call(url).code).to eq code
    end

  end
end
