require "spec_helper"
require 'tester/definition/request'

describe Request do
  let(:request) {Request.new}

  context 'body' do
    it "starts with no fields" do
      expect(request.fields).to eq []
    end

    it "can add fields" do
      request.add_field Field.new("newField")
      expect(request.fields.size).to be 1
      expect(request.fields.first.name).to eq "newField"
    end
  end
end