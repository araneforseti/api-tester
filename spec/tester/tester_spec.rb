require "spec_helper"
require 'webmock/rspec'
require 'tester/response'
require 'tester/request'

describe Tester do
  context 'versioning' do
    it "has a version number" do
      expect(Tester::VERSION).not_to be nil
    end
  end

  context 'get' do
    let(:request) { Request.new "www.example.com" }
    let(:body) { '{"numKey": 1, "string_key": "string"}' }
    let(:definition) { Definition.new.add_field(Field.new("numKey")).add_field(Field.new("string_key")) }
    let(:status_code) { 200 }

    before :each do
      stub_request(:get, "www.example.com").to_return(body: body, status: status_code)
    end

    context 'status code' do
      it 'can pass compatible status code' do
        response = Response.new(status_code, definition)
        expect(Tester.get(request, response)).to be true
      end

      [100, 201, 300, 400, 529].each do | status |
        it "will fail different status code #{status}" do
          response = Response.new(status, definition)
          expect(Tester.get(request, response)).to be false
        end
      end
    end

    context 'body' do
      it 'passes with correct keys' do
        response = Response.new(status_code, definition)
        expect(Tester.get(request, response)).to be true
      end

      # it 'fails when a key is missing' do
      #   response = Response.new(status_code, Definition.new)
      #   expect(Tester.get(request, response)).to be false
      # end
    end
  end
end
