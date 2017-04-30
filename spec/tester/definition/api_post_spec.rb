require "spec_helper"
require 'webmock/rspec'
require 'tester/definition/response'
require 'tester/definition/request'
require 'tester/definition/methods/api_post'

describe ApiPost do
  context 'good request' do
    let(:url) {"www.example.com"}
    let(:request) { Request.new }
    let(:fields) {[Field.new("numKey"), Field.new("string_key")]}
    let(:body) { '{"numKey": 1, "string_key": "string"}' }
    let(:code) { 200 }
    let(:api_post) { ApiPost.new url }
    let(:response) { Response.new code }

    before :each do
      fields.each do |field|
        response.add_field field
      end
      api_post.expected_response = response
      api_post.request = request

      stub_request(:post, url).to_return(body: body, status: code)
    end

    it 'should call' do
      expect(api_post.call.code).to eq code
    end
  end
end