# frozen_string_literal: true

require 'spec_helper'
require 'api-tester/definition/fields/email_field'

describe ApiTester::EmailField do
  context 'default params' do
    let(:default_email) { ApiTester::EmailField.new(name: 'defaultTest') }

    it 'defaults required to false' do
      expect(default_email.required).to be false
    end

    it 'defaults default_value to true' do
      expect(default_email.default_value).to eq 'test@test.com'
    end
  end

  context 'default value' do
    it 'can be set' do
      field = ApiTester::EmailField.new(name: 'testObj',
                                        default_value: 'a@test.com')
      expect(field.default_value).to eq 'a@test.com'
    end
  end

  context 'required negative_boundary_values' do
    context 'for required' do
      let(:negative_boundary_values) { ApiTester::EmailField.new(name: 'testObj').is_required.negative_boundary_values }

      {
        non_email_string: 'string',
        number: 123,
        zero: 0,
        one: 1,
        false: false,
        true: true
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
      let(:negative_boundary_values) { ApiTester::EmailField.new(name: 'testObj').is_not_required.negative_boundary_values }

      {
        string: 'string',
        number: 123,
        zero: 0,
        one: 1,
        falsey: false,
        truey: true
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
