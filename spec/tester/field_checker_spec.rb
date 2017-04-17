require 'rspec'
require 'tester/field_checker'
require 'tester/fields/field'

describe FieldChecker do
  let(:fieldChecker) { FieldChecker.new }

  context 'root fields' do
    it 'should return false if field is not in hash' do
      field = Field.new "fooField"
      hash = {}
      expect(fieldChecker.is_field_in_hash(field, hash)).to be false
    end

    it 'should return true if field is in hash' do
      field = Field.new "fooField"
      hash = { "fooField"=>"123" }
      expect(fieldChecker.is_field_in_hash(field, hash)).to be true
    end

    it 'should return false if not passed a hash' do
      field = Field.new "fooField"
      hash = ["fooField"]
      expect(fieldChecker.is_field_in_hash(field, hash)).to be false
    end
  end

  context 'subfields' do
    it 'should handle object fields' do
      subfield = Field.new "subField"
      field = ObjectField.new("objectField").with_field(subfield)
      hash = { "objectField" => {"subField" => 1} }
      expect(fieldChecker.is_field_in_hash(field, hash)).to be true
    end

    it 'should be able to identify when missing subfields' do
      subfield = Field.new "subField"
      field = ObjectField.new("objectField").with_field(subfield)
      hash = { "objectField" => {"notSubField" => 1} }
      expect(fieldChecker.is_field_in_hash(field, hash)).to be false
    end
  end
end