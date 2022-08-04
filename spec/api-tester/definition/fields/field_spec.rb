# frozen_string_literal: true

require 'spec_helper'
require 'api-tester/definition/fields/field'

describe ApiTester::Field do
  context 'with default' do
    let(:field) { described_class.new name: 'testObj' }

    it 'defaults required to false' do
      expect(field.required).to be false
    end

    it 'defaults default to \'string\'' do
      expect(field.default).to eq 'string'
    end

    it 'defaults seen count to 0' do
      expect(field.is_seen).to be 0
    end
  end

  context 'with default value' do
    it 'can be set' do
      field = described_class.new(name: 'testObj', default: 'new foo')
      expect(field.default).to eq 'new foo'
    end
  end

  context 'with seen' do
    it 'increments' do
      field = described_class.new(name: 'testOb')
      field.seen
      field.seen
      expect(field.is_seen).to be 2
    end
  end

  context 'with required field' do
    it 'has a nil negative boundary case' do
      field = described_class.new(name: 'testOb').is_required
      expect(field.negative_boundary_values).to include nil
    end
  end

  context 'when not required field' do
    it 'does not have a nil negative boundary case' do
      field = described_class.new(name: 'testOb').is_not_required
      expect(field.negative_boundary_values).not_to include nil
    end
  end

  describe '#fields' do
    it 'returns empty' do
      field = described_class.new(name: 'testOb')
      expect(field.fields).to eq []
    end
  end
end
