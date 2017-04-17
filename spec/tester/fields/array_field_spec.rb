require "spec_helper"
require 'tester/fields/array_field'

describe ArrayField do
  context "fields" do
    field = ArrayField.new("testObj")

    it "starts with no fields" do
      expect(field.fields.size).to be 0
    end

    it "can add fields" do
      field = ArrayField.new("testObj")
      field.with_field Field.new("newField")
      expect(field.fields.size).to be 1
      expect(field.fields.first.name).to eq "newField"
    end
  end
end