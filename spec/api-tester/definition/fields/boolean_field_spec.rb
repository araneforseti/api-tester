# frozen_string_literal: true

require 'spec_helper'
require 'api-tester/definition/fields/boolean_field'

describe ApiTester::BooleanField do
  context 'with default params' do
    let(:default_boolean) { described_class.new(name: 'defaultTest') }

    it 'defaults required to false' do
      expect(default_boolean.required).to be false
    end

    it 'defaults default to true' do
      expect(default_boolean.default).to be true
    end
  end

  context 'with default value' do
    it 'can be set to false' do
      field = described_class.new(name: 'testObj', default: false)
      expect(field.default).to be false
    end

    it 'can be set to true' do
      field = described_class.new(name: 'testObj', default: true)
      expect(field.default).to be true
    end
  end

  context 'with required negative_boundary_values' do
    context 'when required' do
      let(:negative_boundary_values) { described_class.new(name: 'testObj').is_required.negative_boundary_values }

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

    context 'when not required' do
      let(:negative_boundary_values) { described_class.new(name: 'testObj').is_not_required.negative_boundary_values }

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
