require "spec_helper"
require 'webmock/rspec'
require 'tester/definition/response'
require 'tester/definition/request'
require 'tester/definition/methods/api_options'

describe ApiOptions do
  context 'good request' do
    let(:url) {"www.example.com"}
    let(:request) { Request.new }
    let(:fields) {[Field.new("numKey"),
                   Field.new("string_key"),
                   ObjectField.new("object_field")
                       .with_field(Field.new "inner_field")
                       .with_field(Field.new("other_field"))]}
    let(:body) { '{"numKey": 1, "string_key": "string", "object_field": {"inner_field": "string", "other_field": "string"}}' }
    let(:code) { 200 }
    let(:api_options) { ApiOptions.new }
    let(:response) { Response.new code }

    before :each do
      fields.each do |field|
        response.add_field field
      end
      api_options.expected_response = response
      api_options.request = request

      stub_request(:options, "www.example.com").to_return(body: body, status: code)
    end

    it 'should call' do
      expect(api_options.call(url).code).to eq code
    end

  end
end
