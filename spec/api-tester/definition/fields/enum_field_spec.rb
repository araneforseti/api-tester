# frozen_string_literal: true

require 'spec_helper'
require 'api-tester/definition/fields/enum_field'

describe ApiTester::EnumField do
  context 'when created with no default, just acceptable values' do
    field = described_class.new(name: 'testObj',
                                acceptable_values: %w[1 2 3])

    it 'retrieves values' do
      expect(field.acceptable_values).to eq %w[1 2 3]
    end

    it 'sets default value to first' do
      expect(field.default).to eq '1'
    end
  end

  context 'when created with default and acceptable values' do
    field = described_class.new(name: 'testObj',
                                acceptable_values: %w[1 2 3],
                                default: '2')

    it 'retrieves values' do
      expect(field.acceptable_values).to eq %w[1 2 3]
    end

    it 'sets default value to first' do
      expect(field.default).to eq '2'
    end
  end

  context 'with required negative_boundary_values' do
    context 'when required' do
      let(:negative_boundary_values) { described_class.new(name: 'testObj', acceptable_values: %w[1 2 3]).is_required.negative_boundary_values }

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

    context 'when not required' do
      let(:negative_boundary_values) { described_class.new(name: 'testObj', acceptable_values: %w[1 2 3]).is_not_required.negative_boundary_values }

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
