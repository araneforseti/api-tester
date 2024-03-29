# frozen_string_literal: true

require 'api-tester/modules/server_information'

describe ApiTester::ServerInformation do
  let(:url) { 'test.com' }
  let(:contract) { ApiTester::Contract.new name: 'Test', base_url: url }
  let(:endpoint) { ApiTester::Endpoint.new name: 'Test Endpoint', relative_url: '' }

  before do
    endpoint.add_method verb: ApiTester::SupportedVerbs::GET,
                        response: ApiTester::Response.new,
                        request: ApiTester::Request.new
    contract.add_endpoint endpoint
  end

  it 'does not generate reports if server is not broadcasting info' do
    stub_request(:get, url).to_return(body: '', status: 200)
    expect(described_class.go(contract).size).to eq 0
  end

  it 'generates a report if server is broadcasting its info in server' do
    stub_request(:get, url).to_return(body: '',
                                      status: 200,
                                      headers: { 'Server' => 'A server' })
    expect(described_class.go(contract).size).to eq 1
  end

  it 'generates a report if server is broadcasting x-powered-by' do
    stub_request(:get, url).to_return(body: '',
                                      status: 200,
                                      headers: { 'x-powered-by' => 'A server' })
    expect(described_class.go(contract).size).to eq 1
  end

  it 'generates a report if server is broadcasting x-aspnetmvc-version' do
    stub_request(:get, url).to_return(body: '',
                                      status: 200,
                                      headers: { 'x-aspnetmvc-version' => 'A server' })
    expect(described_class.go(contract).size).to eq 1
  end

  it 'generates a report if server is broadcasting x-aspnet-version' do
    stub_request(:get, url).to_return(body: '',
                                      status: 200,
                                      headers: { 'x-aspnet-version' => 'A server' })
    expect(described_class.go(contract).size).to eq 1
  end
end
