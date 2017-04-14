require "spec_helper"
require 'tester/request'

describe Request do
  let(:url) {"http://example.com"}
  let(:request) {Request.new url}

  context "url" do
    it "starts has url" do
      expect(request.url).to eq url
    end
  end

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