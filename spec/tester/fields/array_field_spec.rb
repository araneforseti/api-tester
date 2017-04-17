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

  context "default value" do
    it 'defaults to [] with no fields' do
      field = ArrayField.new("testObj")
      expect(field.default_value).to eq []
    end

    it "contains defaults from the fields" do
      sub_field = Field.new "sub", "default_foo"
      field = ArrayField.new("testObj").with_field(sub_field)
      expect(field.default_value).to eq [{"sub" => "default_foo"}]
    end
  end
end