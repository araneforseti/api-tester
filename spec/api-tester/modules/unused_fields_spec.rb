require "spec_helper"
require 'webmock/rspec'
require 'api-tester/definition/response'
require 'api-tester/definition/request'
require 'api-tester/definition/endpoint'
require 'api-tester/modules/unused_fields'
require 'api-tester/reporter/api_report'

describe ApiTester::UnusedFields do
  context 'post request' do
    let(:url) {"www.example.com"}
    let(:request) { ApiTester::Request.new }
    let(:fields) {[ApiTester::Field.new("numKey"), ApiTester::Field.new("string_key")]}
    let(:body) { '{"numKey": 1, "string_key": "string"}' }
    let(:code) { 200 }
    let(:response) { ApiTester::Response.new code }
    let(:endpoint) {ApiTester::Endpoint.new "Test", url}
    let(:unused_fields) {ApiTester::UnusedFields.new}
    let(:report) {ApiTester::ApiReport.new}

    before :each do
      fields.each do |field|
        response.add_field field
      end      
      endpoint.add_method ApiTester::SupportedVerbs::POST, response, request
    end

    context 'no fields marked' do
      it 'fails' do
        expect(unused_fields.go(endpoint, report)).to eq false
      end

      it 'adds no reports' do
        unused_fields.go(endpoint, report)
        expect(report.reports.size).to eq fields.size
      end
    end

    context 'all fields marked' do
      before :each do
        fields.each do |field|
          field.seen
        end
      end

      it 'passes' do
        expect(unused_fields.go(endpoint, report)).to be true
      end

      it 'does not add to report' do
        unused_fields.go(endpoint, report)
        expect(report.reports.size).to be 0
      end
    end

    context 'only one field marked' do
      before :each do
        marked_field = ApiTester::Field.new "testField"
        marked_field.seen
        response.add_field marked_field
      end

      it 'fails' do
        expect(unused_fields.go(endpoint, report)).to be false
      end

      it 'adds no reports' do
        unused_fields.go(endpoint, report)
        expect(report.reports.size).to eq fields.size
      end
    end
  end
end
