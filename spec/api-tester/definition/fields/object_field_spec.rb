require "spec_helper"
require 'api-tester/definition/fields/object_field'

describe ApiTester::ObjectField do
  context "fields" do
    object = ApiTester::ObjectField.new("testObj")

    it "starts with no fields" do
      expect(object.fields.size).to be 0
    end

    it "can add fields" do
      object = ApiTester::ObjectField.new("testObj")
      object.with_field ApiTester::Field.new("newField")
      expect(object.fields.size).to be 1
      expect(object.fields.first.name).to eq "newField"
    end
  end

  context "default value" do
    it 'defaults to {} with no fields' do
      field = ApiTester::ObjectField.new("testObj")
      expect(field.default_value).to eq Hash.new
    end

    it "contains defaults from the fields" do
      sub_field = ApiTester::Field.new "sub", "default_foo"
      field = ApiTester::ObjectField.new("testObj").with_field(sub_field)
      value = Hash.new
      value["sub"] = "default_foo"
      expect(field.default_value).to eq value
    end
  end

  context 'required negative_boundary_values' do
    context 'for required' do
      let(:negative_boundary_values) {ApiTester::ObjectField.new("testObj").is_required.negative_boundary_values}

      {
          'string' => 'string',
          'number' => 123,
          'number 0' => 0,
          'number 1' => 1,
          'boolean true' => true,
          'boolean false' => false
      }.each do |name, value|
        it "contains #{name}" do
          expect(negative_boundary_values).to include value
        end
      end

      it 'contains nil' do
        expect(negative_boundary_values).to include nil
      end
    end

    context 'for not required' do
      let(:negative_boundary_values) {ApiTester::ObjectField.new("testObj").is_not_required.negative_boundary_values}

      {
          'string' => 'string',
          'number' => 123,
          'number 0' => 0,
          'number 1' => 1,
          'boolean true' => true,
          'boolean false' => false
      }.each do |name, value|
        it "contains #{name}" do
          expect(negative_boundary_values).to include value
        end
      end

      it 'does not contains nil' do
        expect(negative_boundary_values).not_to include nil
      end
    end
  end
end