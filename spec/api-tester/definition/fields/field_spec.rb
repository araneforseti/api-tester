require 'spec_helper'
require 'api-tester/definition/fields/field'

describe ApiTester::Field do
  context 'default' do
    let(:field) { ApiTester::Field.new name: 'testObj' }
    it 'defaults required to false' do
      expect(field.required).to be false
    end

    it 'defaults default_value to \'string\'' do
      expect(field.default_value).to eq 'string'
    end

    it 'defaults seen count to 0' do
      expect(field.is_seen).to be 0
    end
  end

  context 'default value' do
    it 'can be set' do
      field = ApiTester::Field.new(name: 'testObj', default_value: 'new foo')
      expect(field.default_value).to eq 'new foo'
    end
  end

  context 'seen' do
    it 'increments' do
      field = ApiTester::Field.new(name: 'testOb')
      field.seen
      field.seen
      expect(field.is_seen).to be 2
    end
  end

  context 'required field' do
    it 'has a nil negative boundary case' do
      field = ApiTester::Field.new(name: 'testOb').is_required
      expect(field.negative_boundary_values).to include nil
    end
  end

  context 'not required field' do
    it 'does not have a nil negative boundary case' do
      field = ApiTester::Field.new(name: 'testOb').is_not_required
      expect(field.negative_boundary_values).not_to include nil
    end
  end

  context '#fields' do
    it 'should return empty' do
      field = ApiTester::Field.new(name: 'testOb')
      expect(field.fields).to eq []
    end
  end
end
