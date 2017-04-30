require "spec_helper"
require 'webmock/rspec'
require 'tester/definition/response'
require 'tester/definition/request'
require 'tester/definition/api_get'

describe ApiGet do
  context 'good request' do
    let(:url) {"www.example.com"}
    let(:request) { Request.new }
    let(:fields) {[Field.new("numKey"),
                   Field.new("string_key"),
                   ObjectField.new("object_field")
                       .with_field(Field.new "inner_field")
                       .with_field(Field.new("other_field"))]}
    let(:body) { '{"numKey": 1, "string_key": "string", "object_field": {"inner_field": "string", "other_field": "string"}}' }
    let(:status_code) { 200 }
    let(:api_get) { ApiGet.new url }
    let(:response) { Response.new status_code }

    before :each do
      fields.each do |field|
        response.add_field field
      end
      api_get.expected_response = response
      api_get.request = request

      stub_request(:get, "www.example.com").to_return(body: body, status: status_code)
    end

    context 'status code' do
      it 'can pass compatible status code' do
        expect(api_get.go).to be true
      end

      [100, 201, 300, 400, 529].each do | status |
        it "will fail different status code #{status}" do
          response.status_code = status
          api_get.expected_response = response
          expect(api_get.go).to be false
        end
      end
    end

    context 'body' do
      it 'passes with correct keys' do
        expect(api_get.go).to be true
      end

      it 'fails when a key is missing' do
        response.add_field(Field.new("missingField"))
        api_get.expected_response = response
        expect(api_get.go).to be false
      end

      context 'empty response' do
        it 'fails when expecting keys which are not there' do
          stub_request(:get, "www.example.com").to_return(body: '[]', status: status_code)
          expect(api_get.go).to be false
        end

        it 'passes when expecting an empty body' do
          stub_request(:get, "www.example.com").to_return(body: '[]', status: status_code)
          response = Response.new 200
          api_get.expected_response = response
          expect(api_get.go).to be true
        end
      end
    end
  end
end