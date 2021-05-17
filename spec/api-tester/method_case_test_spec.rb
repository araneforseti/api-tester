# frozen_string_literal: true

describe ApiTester::MethodCaseTest do
  let(:payload) { '{}' }
  let(:response) { MockResponse.new 200, '{"numKey": 1, "string_key": "string"}' }
  let(:expected_response) { ApiTester::Response.new status_code: 200 }
  let(:url) { '' }
  let(:verb) { 'GET' }
  let(:module_name) { 'test' }
  let(:method) {
    ApiTester::MethodCaseTest.new response: response,
                                  payload: payload,
                                  expected_response: expected_response,
                                  url: url,
                                  verb: verb,
                                  module_name: module_name
  }

  context '#response_code_report' do
    it 'should add to the reports' do
      method.response_code_report
      expect(method.reports.size).to eq(1)
    end

    it 'should add to the reports' do
      method.reports = %w[1 2]
      method.response_code_report
      expect(method.reports.size).to eq(3)
    end
  end

  context '#missing_field_report' do
    it 'should add to the reports' do
      method.response_code_report
      expect(method.reports.size).to eq(1)
    end
  end

  context '#extra_field_report' do
    it 'should add to the reports' do
      method.response_code_report
      expect(method.reports.size).to eq(1)
    end
  end

  context '#check_response_code negative case' do
    let(:expected_response) { ApiTester::Response.new status_code: 400 }
    let(:method) {
      ApiTester::MethodCaseTest.new response: response,
                                    payload: payload,
                                    expected_response: expected_response,
                                    url: url,
                                    verb: verb,
                                    module_name: module_name
    }

    it 'should return false' do
      expect(method.check_response_code).to eq(false)
    end

    it 'should add to reports' do
      expect(method.reports.size).to eq(0)
      method.check_response_code
      expect(method.reports.size).to eq(1)
    end
  end

  context '#check_response_code positive case' do
    it 'should return false' do
      expect(method.check_response_code).to eq(true)
    end

    it 'should not change the reports' do
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
