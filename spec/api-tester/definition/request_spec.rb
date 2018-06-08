require "spec_helper"
require 'api-tester/definition/request'

describe ApiTester::Request do
  let(:request) {ApiTester::Request.new}

  context 'body' do
    it "starts with no fields" do
      expect(request.fields).to eq []
    end

    it "can add fields" do
      request.add_field ApiTester::Field.new(name: "newField")
      expect(request.fields.size).to be 1
      expect(request.fields.first.name).to eq "newField"
    end
  end

  context 'headers' do
    context 'no headers set' do
      it 'has default headers of content_type and accept' do
        expect(request.default_headers).to eq({content_type: :json, accept: :json})
      end
    end

    context 'headers set to nothing' do
      before :each do
        request.header_fields = {}
      end

      it 'has no headers' do
        expect(request.headers).to eq({})
      end

      it 'has default headers of nothing' do
        expect(request.default_headers).to eq({})
      end
    end

    context 'headers set to something' do
      before :each do
        request.add_header_field ApiTester::Field.new(name: :Authorization, required: true, default_value: "something")
      end

      it 'has no headers' do
        expect(request.headers.size).to be 1
      end

      it 'has default headers using field default' do
        expect(request.default_headers).to eq({Authorization: "something"})
      end
    end
  end
  
  context 'query_params' do
    it 'defaults to no query params' do
      expect(request.query_params.size).to be 0
    end

    it 'contains added params' do
      request.add_query_param ApiTester::Field.new name: "query"
      expect(request.query_params[0].name).to eq "query"
    end

    it 'generates default url query' do
      request.add_query_param ApiTester::Field.new name: "query", default_value: "default"
      request.add_query_param ApiTester::Field.new name: "query2", default_value: "something"
      expect(request.default_query).to eq "query=default&query2=something"
    end
  end
end
