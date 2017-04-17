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

  context 'object fields' do
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

  context 'array fields' do
    it 'should handle array fields' do
      subfield = Field.new "subField"
      field = ArrayField.new("arrayField").with_field(subfield)
      hash = { "arrayField" => [{"subField" => 1}] }
      expect(fieldChecker.is_field_in_hash(field, hash)).to be true
    end

    it 'should be able to identify when array is missing subfields' do
      subfield = Field.new "subField"
      field = ArrayField.new("arrayField").with_field(subfield)
      hash = { "arrayField" => [{"notSubField" => 1}] }
      expect(fieldChecker.is_field_in_hash(field, hash)).to be false
    end
  end

  context '#check_object_subfields' do
    it 'should id subfields in hash passed' do
      field = ObjectField.new("obj").with_field(Field.new "subField")
      field_hash = {"obj" => {"subField" => "foo"}}
      expect(fieldChecker.check_object_subfields(field, field_hash)).to be true
    end

    it 'should fail if missing the subfield' do
      field = ObjectField.new("obj").with_field(Field.new "subField")
      field_hash = {"obj" => {"not_sub_field" => "foo"}}
      expect(fieldChecker.check_object_subfields(field, field_hash)).to be false
    end
  end
end