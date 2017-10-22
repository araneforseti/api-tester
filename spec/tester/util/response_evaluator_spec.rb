require 'tester/util/response_evaluator'

describe ResponseEvaluator do
    describe '#response_field_array' do
        it 'should create the field array' do
            example_body = {"name": "Nam", "key": "value", "hash": {"innerkey": 1, "innerkey2": 2}}
            evaluator = ResponseEvaluator.new example_body, Response.new(200)
            expect(evaluator.response_field_array).to eq ["name", "key", "hash", "hash.innerkey", "hash.innerkey2"]
        end
    end

    describe '#expected_fields' do
        it 'should create the field array' do
            response = Response.new 200
            object_field = ObjectField.new("hash").with_field(Field.new "innerkey").with_field(Field.new "innerkey2")
            response.add_field(Field.new "name").add_field(Field.new "key").add_field(object_field)
            evaluator = ResponseEvaluator.new({}, response)
            expect(evaluator.expected_fields).to eq ["name", "key", "hash", "hash.innerkey", "hash.innerkey2"]
        end
    end

    describe '#extra_fields' do
        it 'should return the extra fields' do
            example_body = {"name": "Nam", "key": "value", "hash": {"innerkey": 1, "innerkey2": 2}}
            response = Response.new 200
            response.add_field(Field.new "name").add_field(Field.new "key")
            evaluator = ResponseEvaluator.new(example_body, response)
            expect(evaluator.extra_fields).to eq ["hash", "hash.innerkey", "hash.innerkey2"]
        end
    end

    describe '#missing_fields' do
        it 'should return the missing fields' do
            example_body = {"hash": {"innerkey": 1, "innerkey2": 2}}
            response = Response.new 200
            object_field = ObjectField.new("hash").with_field(Field.new "innerkey").with_field(Field.new "innerkey2")
            response.add_field(Field.new "name").add_field(Field.new "key").add_field(object_field)
            evaluator = ResponseEvaluator.new(example_body, response)
            expect(evaluator.missing_fields).to eq ["name", "key"]
        end
    end
end
