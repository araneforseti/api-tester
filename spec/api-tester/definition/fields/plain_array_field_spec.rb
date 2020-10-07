require "spec_helper"
require 'api-tester/definition/fields/plain_array_field'

describe ApiTester::BooleanField do
  context 'default params' do
    let(:default_array) { ApiTester::PlainArrayField.new(name: 'defaultTest') }

    it 'defaults required to false' do
      expect(default_array.required).to be false
    end

    it 'defaults default_value to empty array' do
      expect(default_array.default_value).to eq []
    end
  end

  context 'default value' do
    it 'can be set to something' do
      value = ["foo", "bar"]
      field = ApiTester::PlainArrayField.new(name: 'testObj', default_value: value)
      expect(field.default_value).to eq value
    end

    it 'can be set to empty array' do
      value = []
      field = ApiTester::BooleanField.new(name: 'testObj', default_value: value)
      expect(field.default_value).to eq value
    end
  end

  context 'negative_boundary_values' do
    context 'for required' do
      let(:negative_boundary_values) {ApiTester::PlainArrayField.new(name: 'testObj').is_required.negative_boundary_values}

      {
        'string' => 'string',
        'number' => 123,
        'number 0' => 0,
        'number 1' => 1,
        'object' => {},
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
      let(:negative_boundary_values) {ApiTester::PlainArrayField.new(name: 'testObj').is_not_required.negative_boundary_values}

      {
        'string' => 'string',
        'number' => 123,
        'number 0' => 0,
        'number 1' => 1,
        'object' => {},
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
