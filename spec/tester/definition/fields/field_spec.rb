require "spec_helper"
require 'tester/definition/fields/field'

describe Field do
  context 'default params' do
    it 'defaults required to false' do
      expect(Field.new("testObj").required).to be false
    end

    it 'defaults default_value to "string"' do
      field = Field.new("testObj")
      expect(field.default_value).to eq "string"
    end
  end

  context "default value" do
    it "can be set" do
      field = Field.new("testObj", "new foo")
      expect(field.default_value).to eq "new foo"
    end
  end

  context 'required field' do
    it 'has a nil negative boundary case' do
      field = Field.new("testOb").is_required
      expect(field.negative_boundary_values).to include nil
    end
  end

  context 'not required field' do
    it 'does not have a nil negative boundary case' do
      field = Field.new("testOb").is_not_required
      expect(field.negative_boundary_values).not_to include nil
    end
  end
end