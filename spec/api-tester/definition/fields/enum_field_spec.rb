require "spec_helper"
require 'api-tester/definition/fields/enum_field'

describe ApiTester::EnumField do
  context "created with no default, just acceptable values" do
    field = ApiTester::EnumField.new(name: "testObj", acceptable_values: ["1", "2", "3"])

    it 'retrieves values' do
      expect(field.acceptable_values).to eq ["1", "2", "3"]
    end

    it 'sets default value to first' do
      expect(field.default_value).to eq "1"
    end
  end

  context "created with default and acceptable values" do
    field = ApiTester::EnumField.new(name: "testObj", acceptable_values: ["1", "2", "3"], default_value: "2")

    it 'retrieves values' do
      expect(field.acceptable_values).to eq ["1", "2", "3"]
    end

    it 'sets default value to first' do
      expect(field.default_value).to eq "2"
    end
  end

  context 'required negative_boundary_values' do
    context 'for required' do
      let(:negative_boundary_values) {ApiTester::EnumField.new(name: "testObj", acceptable_values: ["1", "2", "3"]).is_required.negative_boundary_values}

      {
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
      let(:negative_boundary_values) {ApiTester::EnumField.new(name: "testObj", acceptable_values: ["1", "2", "3"]).is_not_required.negative_boundary_values}

      {
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