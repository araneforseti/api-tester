require 'api-tester/util/response_evaluator'

describe ApiTester::ResponseEvaluator do
  describe '#response_field_array' do
    it 'should create the field array' do
      example_body = { 'name': 'Nam', 'key': 'value',
                       'hash': {'innerkey': 1, 'innerkey2': 2 } }
      evaluator = ApiTester::ResponseEvaluator.new example_body,
                                                   ApiTester::Response.new(200)
      expect(evaluator.response_field_array).to eq ['name',
                                                    'key',
                                                    'hash',
                                                    'hash.innerkey',
                                                    'hash.innerkey2']
    end
 
    it 'should create this field array' do
      example_body = {'numKey': 1, 'string_key': 'string'}
      evaluator = ApiTester::ResponseEvaluator.new example_body,
                                                   ApiTester::Response.new(200)
      expect(evaluator.response_field_array).to eq %w[numKey string_key]
    end

    it 'should handle arrays' do
      example_body = { 'arr': [{ 'numKey': 1, 'string_key': 'string' }] }
      evaluator = ApiTester::ResponseEvaluator.new example_body,
                                                   ApiTester::Response.new(200)
      expect(evaluator.response_field_array).to eq ['arr',
                                                    'arr.numKey',
                                                    'arr.string_key']
    end
  end

  describe '#expected_fields' do
    it 'should create the field array' do
      response = ApiTester::Response.new 200
      object_field = ApiTester::ObjectField.new(name: 'hash').with_field(ApiTester::Field.new(name: 'innerkey')).with_field(ApiTester::Field.new(name: 'innerkey2'))
      response.add_field(ApiTester::Field.new(name: 'name')).add_field(ApiTester::Field.new(name: 'key')).add_field(object_field)
      evaluator = ApiTester::ResponseEvaluator.new({}, response)
      expect(evaluator.expected_fields).to eq ['name',
                                               'key',
                                               'hash',
                                               'hash.innerkey',
                                               'hash.innerkey2']
    end
  end

  describe '#expected_fields_hash' do
    it 'should create the field hash' do
      response = ApiTester::Response.new 200
      innerkey = ApiTester::Field.new name: 'innerkey'
      innerkey2 = ApiTester::Field.new name: 'innerkey2'
      object_field = ApiTester::ObjectField.new(name: 'hash').with_field(innerkey).with_field(innerkey2)
      name_field = ApiTester::Field.new name: 'name'
      key_field = ApiTester::Field.new name: 'key'
      response.add_field(name_field).add_field(key_field).add_field(object_field)
      evaluator = ApiTester::ResponseEvaluator.new({}, response)
      expect(hash_compare(
               evaluator.expected_fields_hash,
               'name': name_field, 'key': key_field, 'hash': object_field,
               'hash.innerkey': innerkey, 'hash.innerkey2': innerkey2
             )).to be true
    end
  end

  describe '#extra_fields' do
    it 'should return the extra fields' do
      example_body = { 'name': 'Nam',
                       'key': 'value',
                       'hash': { 'innerkey': 1, 'innerkey2': 2 } }
      response = ApiTester::Response.new 200
      response.add_field(ApiTester::Field.new(name: 'name')).add_field(ApiTester::Field.new name: 'key')
      evaluator = ApiTester::ResponseEvaluator.new(example_body, response)
      expect(evaluator.extra_fields).to eq ['hash',
                                            'hash.innerkey',
                                            'hash.innerkey2']
    end
  end

  describe '#missing_fields' do
    it 'should return the missing fields' do
      example_body = { 'hash': { 'innerkey': 1, 'innerkey2': 2 } }
      response = ApiTester::Response.new 200
      object_field = ApiTester::ObjectField.new(name: 'hash').with_field(ApiTester::Field.new name: 'innerkey').with_field(ApiTester::Field.new name: 'innerkey2')
      response.add_field(ApiTester::Field.new(name: 'name')).add_field(ApiTester::Field.new name: 'key').add_field(object_field)
      evaluator = ApiTester::ResponseEvaluator.new(example_body, response)
      expect(evaluator.missing_fields).to eq %w[name key]
    end

    it 'should recognize arrays' do
      example_body = { 'sheets': [{ 'strength': 10 }] }
      response = ApiTester::Response.new 200
      array_field = ApiTester::ArrayField.new(name: 'sheets').with_field(ApiTester::Field.new name: 'strength').with_field(ApiTester::Field.new name: 'missingkey')
      response.add_field(array_field)
      evaluator = ApiTester::ResponseEvaluator.new(example_body, response)
      expect(evaluator.missing_fields).to eq ['sheets.missingkey']
    end 
  end

  describe '#seen_fields' do
    it 'should return an array of seen field objects' do
      example_body = { 'name': 'Nam', 'hash': { 'innerkey2': 2 } }
      response = ApiTester::Response.new 200
      innerkey = ApiTester::Field.new name: 'innerkey'
      innerkey2 = ApiTester::Field.new name: 'innerkey2'
      object_field = ApiTester::ObjectField.new(name: 'hash').with_field(innerkey).with_field(innerkey2)
      name_field = ApiTester::Field.new name: 'name'
      key_field = ApiTester::Field.new name: 'key'
      response.add_field(name_field).add_field(key_field).add_field(object_field)
      evaluator = ApiTester::ResponseEvaluator.new(example_body, response)
      expect(evaluator.seen_fields).to eq [name_field, object_field, innerkey2]
    end
  end

  def hash_compare(hash1, hash2)
    key1 = hash1.keys.map(&:to_s)
    key2 = hash2.keys.map(&:to_s)
    if key1 == key2
      hash1.each do |key, value|
        if hash2[key.to_sym] != value
          puts "For #{key}, #{value} != #{hash2[key]}"
          puts "    in #{hash2}"
          return false
        end
      end
    else
      puts "#{key1} != #{key2}"
      return false
    end
    true
  end
end
