require "spec_helper"
require 'tester/fields/field'

describe Field do
  context "default value" do
    it 'defaults to "string"' do
      field = Field.new("testObj")
      expect(field.default_value).to eq "string"
    end

    it "can be set" do
      field = Field.new("testObj", "new foo")
      expect(field.default_value).to eq "new foo"
    end
  end
end