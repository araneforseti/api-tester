# frozen_string_literal: true

describe ApiTester::MethodCaseTest do
  let(:payload) { '{}' }
  let(:response) { MockResponse.new 200, '{"numKey": 1, "string_key": "string"}' }
  let(:expected_response) { ApiTester::Response.new status_code: 200 }
  let(:url) { '' }
  let(:verb) { 'GET' }
  let(:module_name) { 'test' }
  let(:method) {
    described_class.new response: response,
                        payload: payload,
                        expected_response: expected_response,
                        url: url,
                        verb: verb,
                        module_name: module_name
  }

  describe '#response_code_report' do
    it 'adds to the reports' do
      method.response_code_report
      expect(method.reports.size).to eq(1)
    end

    it 'adds multiple to the reports when given multiple' do
      method.reports = %w[1 2]
      method.response_code_report
      expect(method.reports.size).to eq(3)
    end
  end

  describe '#missing_field_report' do
    it 'adds to the reports' do
      method.response_code_report
      expect(method.reports.size).to eq(1)
    end
  end

  describe '#check_response_code negative case' do
    let(:expected_response) { ApiTester::Response.new status_code: 400 }
    let(:method) {
      described_class.new response: response,
                          payload: payload,
                          expected_response: expected_response,
                          url: url,
                          verb: verb,
                          module_name: module_name
    }

    it 'returns false' do
      expect(method.check_response_code).to be(false)
    end

    it 'adds to reports' do
      expect(method.reports.size).to eq(0)
      method.check_response_code
      expect(method.reports.size).to eq(1)
    end
  end

  describe '#check_response_code positive case' do
    it 'returns false' do
      expect(method.check_response_code).to be(true)
    end

    it 'does not change the reports' do
      method.check_response_code
      expect(method.reports.size).to eq(0)
    end
  end
end

class MockResponse
  attr_accessor :code, :body

  def initialize(code, body)
    self.code = code
    self.body = body
  end
end
