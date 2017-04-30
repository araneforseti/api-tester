require "spec_helper"
require 'webmock/rspec'
require 'tester/definition/response'
require 'tester/definition/request'
require 'tester/definition/api_post'

describe ApiPost do
  context 'good request' do
    let(:url) {"www.example.com"}
    let(:request) { Request.new }
    let(:fields) {[Field.new("numKey"), Field.new("string_key")]}
    let(:body) { '{"numKey": 1, "string_key": "string"}' }
    let(:status_code) { 200 }
    let(:api_post) { ApiPost.new url }
    let(:response) { Response.new status_code }

    before :each do
      fields.each do |field|
        response.add_field field
      end
      api_post.expected_response = response
      api_post.request = request

      stub_request(:post, url).to_return(body: body, status: status_code)
    end

    context 'status code' do
      it 'can pass compatible status code' do
        expect(api_post.go).to be true
      end

      [100, 201, 300, 400, 529].each do | status |
        it "will fail different status code #{status}" do
          response.status_code = status
          api_post.expected_response = response
          expect(api_post.go).to be false
        end
      end
    end

    context 'body' do
      it 'passes with correct keys' do
        expect(api_post.go).to be true
      end

      it 'fails when a key is missing' do
        response.add_field(Field.new("missingField"))
        api_post.expected_response = response
        expect(api_post.go).to be false
      end
    end
  end
end