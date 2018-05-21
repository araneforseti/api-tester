require "spec_helper"
require 'webmock/rspec'
require 'tester/definition/response'
require 'tester/definition/methods/api_delete'

describe ApiDelete do
  context 'good request' do
    let(:url) {"www.example.com"}
    let(:code) { 200 }
    let(:api_delete) { ApiDelete.new }
    let(:response) { Response.new code }

    before :each do
      stub_request(:delete, "www.example.com").to_return(status: code)
      api_delete.expected_response = response
    end

    it 'should call' do
      expect(api_delete.call(url).code).to eq code
    end

  end
end
