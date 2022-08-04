# frozen_string_literal: true

require 'spec_helper'
require 'api-tester/definition/fields/email_field'

describe ApiTester::EmailField do
  context 'with default params' do
    let(:default_email) { described_class.new(name: 'defaultTest') }

    it 'defaults required to false' do
      expect(default_email.required).to be false
    end

    it 'defaults default to true' do
      expect(default_email.default).to eq 'test@test.com'
    end
  end

  context 'with default value' do
    it 'can be set' do
      field = described_class.new(name: 'testObj',
                                  default: 'a@test.com')
      expect(field.default).to eq 'a@test.com'
    end
  end

  context 'with required negative_boundary_values' do
    context 'when required' do
      let(:negative_boundary_values) { described_class.new(name: 'testObj').is_required.negative_boundary_values }

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

    context 'when not required' do
      let(:negative_boundary_values) { described_class.new(name: 'testObj').is_not_required.negative_boundary_values }

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
