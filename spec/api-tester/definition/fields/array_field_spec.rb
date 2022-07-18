# frozen_string_literal: true

require 'spec_helper'
require 'api-tester/definition/fields/array_field'

describe ApiTester::ArrayField do
  context 'fields' do
    field = ApiTester::ArrayField.new name: 'testObj'

    it 'starts with no fields' do
      expect(field.fields.size).to be 0
    end

    it 'can add fields' do
      field = ApiTester::ArrayField.new name: 'testObj'
      field.with_field ApiTester::Field.new(name: 'newField')
      expect(field.fields.size).to be 1
      expect(field.fields.first.name).to eq 'newField'
    end
  end

  context 'default value' do
    it 'defaults to [] with no fields' do
      field = ApiTester::ArrayField.new name: 'testObj'
      expect(field.default).to eq []
    end

    it 'contains defaults from the fields' do
      sub_field = ApiTester::Field.new name: 'sub', default: 'default_foo'
      field = ApiTester::ArrayField.new(name: 'testObj').with_field(sub_field)
      expect(field.default).to eq [{ 'sub' => 'default_foo' }]
    end
  end

  context 'required negative_boundary_values' do
    context 'for required' do
      let(:negative_boundary_values) { ApiTester::ArrayField.new(name: 'testObj').is_required.negative_boundary_values }

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
      let(:negative_boundary_values) { ApiTester::ArrayField.new(name: 'testObj').is_not_required.negative_boundary_values }

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
