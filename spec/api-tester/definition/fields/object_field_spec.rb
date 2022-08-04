# frozen_string_literal: true

require 'spec_helper'
require 'api-tester/definition/fields/object_field'

describe ApiTester::ObjectField do
  context 'with fields' do
    object = described_class.new name: 'testObj'

    it 'starts with no fields' do
      expect(object.fields.size).to be 0
    end

    it 'can add fields' do
      object = described_class.new name: 'testObj'
      object.with_field ApiTester::Field.new(name: 'newField')
      expect(object.fields.size).to be 1
      expect(object.fields.first.name).to eq 'newField'
    end
  end

  context 'with default value' do
    it 'defaults to {} with no fields' do
      field = described_class.new name: 'testObj'
      expect(field.default).to eq Hash.new
    end

    it 'contains defaults from the fields' do
      sub_field = ApiTester::Field.new name: 'sub', default: 'default_foo'
      field = described_class.new(name: 'testObj').with_field(sub_field)
      value = {}
      value['sub'] = 'default_foo'
      expect(field.default).to eq value
    end
  end

  context 'with required negative_boundary_values' do
    context 'when required' do
      let(:negative_boundary_values) { described_class.new(name: 'testObj').is_required.negative_boundary_values }

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

    context 'when not required' do
      let(:negative_boundary_values) { described_class.new(name: 'testObj').is_not_required.negative_boundary_values }

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
