require "spec_helper"
require 'api-tester/definition/request'

describe ApiTester::Request do
  let(:request) {ApiTester::Request.new}

  context 'body' do
    it "starts with no fields" do
      expect(request.fields).to eq []
    end

    it "can add fields" do
      request.add_field ApiTester::Field.new("newField")
      expect(request.fields.size).to be 1
      expect(request.fields.first.name).to eq "newField"
    end
  end
end