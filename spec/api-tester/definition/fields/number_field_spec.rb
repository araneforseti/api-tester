# frozen_string_literal: true

require 'spec_helper'
require 'api-tester/definition/fields/number_field'

describe ApiTester::NumberField do
  context 'with default params' do
    let(:default_number) { described_class.new(name: 'defaultTest') }

    it 'defaults required to false' do
      expect(default_number.required).to be false
    end

    it 'defaults default to true' do
      expect(default_number.default).to eq 5
    end
  end

  context 'with default value' do
    it 'can be set to 0' do
      field = described_class.new(name: 'testObj', default: 0)
      expect(field.default).to eq 0
    end

    it 'can be set to 1' do
      field = described_class.new(name: 'testObj', default: 1)
      expect(field.default).to eq 1
    end
  end

  context 'with required negative_boundary_values' do
    context 'when required' do
      let(:negative_boundary_values) { described_class.new(name: 'testObj').is_required.negative_boundary_values }

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

    context 'when not required' do
      let(:negative_boundary_values) { described_class.new(name: 'testObj').is_not_required.negative_boundary_values }

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
