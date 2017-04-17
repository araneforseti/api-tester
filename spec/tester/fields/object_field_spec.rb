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

  context "default value" do
    it 'defaults to {} with no fields' do
      field = ObjectField.new("testObj")
      expect(field.default_value).to eq Hash.new
    end

    it "contains defaults from the fields" do
      sub_field = Field.new "sub", "default_foo"
      field = ObjectField.new("testObj").with_field(sub_field)
      value = Hash.new
      value["sub"] = "default_foo"
      expect(field.default_value).to eq value
    end
  end
end