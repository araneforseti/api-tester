# frozen_string_literal: true

require 'spec_helper'
require 'api-tester/definition/fields/plain_array_field'

describe ApiTester::BooleanField do
  context 'with default params' do
    let(:default_array) { ApiTester::PlainArrayField.new(name: 'defaultTest') }

    it 'defaults required to false' do
      expect(default_array.required).to be false
    end

    it 'defaults default to empty array' do
      expect(default_array.default).to eq []
    end
  end

  context 'with default value' do
    it 'can be set to something' do
      value = %w[foo bar]
      field = ApiTester::PlainArrayField.new(name: 'testObj', default: value)
      expect(field.default).to eq value
    end

    it 'can be set to empty array' do
      value = []
      field = described_class.new(name: 'testObj', default: value)
      expect(field.default).to eq value
    end
  end

  context 'with negative_boundary_values' do
    context 'when required' do
      let(:negative_boundary_values) { ApiTester::PlainArrayField.new(name: 'testObj').is_required.negative_boundary_values }

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

    context 'when not required' do
      let(:negative_boundary_values) { ApiTester::PlainArrayField.new(name: 'testObj').is_not_required.negative_boundary_values }

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
