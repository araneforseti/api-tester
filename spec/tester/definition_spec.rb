require "spec_helper"
require 'tester/definition/definition'

describe Definition do
  context "fields" do
    definition = Definition.new

    it "starts with no fields" do
      expect(definition.fields.size).to be 0
    end

    it "can add fields" do
      definition = Definition.new
      definition.add_field Field.new("newField")
      expect(definition.fields.size).to be 1
      expect(definition.fields.first.name).to eq "newField"
    end
  end
end