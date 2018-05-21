require "spec_helper"
require 'webmock/rspec'
require 'tester/definition/response'
require 'tester/definition/methods/api_lock'

describe ApiLock do
  context 'good request' do
    let(:url) {"www.example.com"}
    let(:code) { 200 }
    let(:api_lock) { ApiLock.new }
    let(:response) { Response.new code }

    before :each do
      stub_request(:lock, "www.example.com").to_return(status: code)
      api_lock.expected_response = response
    end

    it 'should call' do
      expect(api_lock.call(url).code).to eq code
    end

  end
end
