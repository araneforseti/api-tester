require 'spec_helper'
require 'api-tester/definition/fields/boolean_field'

describe ApiTester::BooleanField do
  context 'default params' do
    let(:default_boolean) { ApiTester::BooleanField.new(name: 'defaultTest') }

    it 'defaults required to false' do
      expect(default_boolean.required).to be false
    end

    it 'defaults default_value to true' do
      expect(default_boolean.default_value).to eq true
    end
  end

  context 'default value' do
    it 'can be set to false' do
      field = ApiTester::BooleanField.new(name: 'testObj', default_value: false)
      expect(field.default_value).to eq false
    end

    it 'can be set to true' do
      field = ApiTester::BooleanField.new(name: 'testObj', default_value: true)
      expect(field.default_value).to eq true
    end
  end

  context 'required negative_boundary_values' do
    context 'for required' do
      let(:negative_boundary_values) { ApiTester::BooleanField.new(name: 'testObj').is_required.negative_boundary_values }

      {
        'string' => 'string',
        'number' => 123,
        'number 0' => 0,
        'number 1' => 1
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
      let(:negative_boundary_values) { ApiTester::BooleanField.new(name: 'testObj').is_not_required.negative_boundary_values }

      {
        'string' => 'string',
        'number' => 123,
        'number 0' => 0,
        'number 1' => 1
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
