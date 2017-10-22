require "spec_helper"
require 'tester/definition/response'

describe Response do
    let(:code) {200}
    let(:response) {Response.new code}

    context "code" do
        it "starts has status_cpde" do
            expect(response.code).to eq code
        end
    end

    context 'fields' do
        it "starts with no fields" do
            expect(response.body).to eq []
        end

        it "can add fields" do
            response.add_field Field.new("newField")
            expect(response.body.size).to be 1
            expect(response.body.first.name).to eq "newField"
        end
    end

    context '#to_s' do
        it "prints out names of fields" do
            response.add_field(Field.new "field1").add_field(Field.new "field2")
            expect(response.to_s).to eq('["field1:Field", "field2:Field"]')
        end

        it "prints out names of inner fields for object fields" do
            object_field = ObjectField.new("obj").with_field(Field.new "inner")
            response.add_field(object_field)
            expect(response.to_s).to eq('["obj:[\"inner:Field\"]"]')
        end

        it "prints out names of inner fields for array fields" do
            array_field = ArrayField.new("arr").with_field(Field.new "inner")
            response.add_field(array_field)
            expect(response.to_s).to eq('["arr:[\"inner:Field\"]"]')
        end
    end
end
