require "spec_helper"
require 'tester/definition/response'

describe Response do
  let(:status_code) {200}
  let(:response) {Response.new status_code}

  context "status_code" do
    it "starts has status_cpde" do
      expect(response.status_code).to eq status_code
    end
  end

  context 'fields' do
    it "starts with no fields" do
      expect(response.body).to eq []
    end

    it "can add fields" do
      response.add_field Field.new("newField")
      expect(response.body.size).to be 1
      expect(response.body.first.name).to eq "newField"
    end
  end
end