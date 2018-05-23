require "spec_helper"
require 'api-tester/definition/fields/number_field'

describe ApiTester::NumberField do
  context 'default params' do
    let(:default_number) {ApiTester::NumberField.new("defaultTest")}

    it 'defaults required to false' do
      expect(default_number.required).to be false
    end

    it 'defaults default_value to true' do
      expect(default_number.default_value).to eq 5
    end
  end

  context "default value" do
    it "can be set to 0" do
      field = ApiTester::NumberField.new("testObj", 0)
      expect(field.default_value).to eq 0
    end

    it "can be set to 1" do
      field = ApiTester::NumberField.new("testObj", 1)
      expect(field.default_value).to eq 1
    end
  end

  context 'required negative_boundary_values' do
    context 'for required' do
      let(:negative_boundary_values) {ApiTester::NumberField.new("testObj").is_required.negative_boundary_values}

      {
          'string' => 'string',
          'false' => false,
          'true' => true
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
      let(:negative_boundary_values) {ApiTester::NumberField.new("testObj").is_not_required.negative_boundary_values}

      {
          'string' => 'string',
          'false' => false,
          'true' => true
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