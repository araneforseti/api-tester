require "spec_helper"
require 'tester/fields/object_field'

describe ObjectField do
  context "fields" do
    object = ObjectField.new("testObj")

    it "starts with no fields" do
      expect(object.fields.size).to be 0
    end

    it "can add fields" do
      object = ObjectField.new("testObj")
      object.with_field Field.new("newField")
      expect(object.fields.size).to be 1
      expect(object.fields.first.name).to eq "newField"
    end
  end
end