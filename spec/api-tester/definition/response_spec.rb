require 'spec_helper'
require 'api-tester/definition/response'

describe ApiTester::Response do
  let(:code) { 200 }
  let(:response) { ApiTester::Response.new status_code: code }

  context 'code' do
    it 'starts has status_code' do
      expect(response.code).to eq code
    end
  end

  context 'fields' do
    it 'starts with no fields' do
      expect(response.body).to eq []
    end

    it 'can add fields' do
      response.add_field ApiTester::Field.new(name: 'newField')
      expect(response.body.size).to be 1
      expect(response.body.first.name).to eq 'newField'
    end
  end

  context '#to_s' do
    it 'prints out names of fields' do
      response.add_field(ApiTester::Field.new(name: 'field1')).add_field(ApiTester::Field.new(name: 'field2'))
      expect(response.to_s).to eq('{"field1":"ApiTester::Field","field2":"ApiTester::Field"}')
    end

    it 'prints out names of inner fields for object fields' do
      object_field = ApiTester::ObjectField.new(name: 'obj').with_field(ApiTester::Field.new(name: 'inner'))
      response.add_field(object_field)
      expect(response.to_s).to eq('{"obj":{"inner":"ApiTester::Field"}}')
    end

    it 'prints out names of inner fields for array fields' do
      array_field = ApiTester::ArrayField.new(name: 'arr').with_field(ApiTester::Field.new(name: 'inner'))
      response.add_field(array_field)
      expect(response.to_s).to eq('{"arr":{"inner":"ApiTester::Field"}}')
    end
  end
end
