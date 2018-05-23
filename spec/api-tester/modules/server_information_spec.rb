require 'api-tester/modules/server_information'

describe ApiTester::ServerInformation do
  let(:url) {"test.com"}
  let(:contract) {ApiTester::ApiContract.new "Test"}
  let(:endpoint) {ApiTester::Endpoint.new "Test Endpoint", url}

  before(:each) do
    endpoint.add_method ApiTester::SupportedVerbs::GET,
      ApiTester::Response.new,
      ApiTester::Request.new
    contract.add_endpoint endpoint
  end

  it 'should not generate reports if server is not broadcasting info' do
    stub_request(:get, url).to_return(body: "", status: 200)
    expect(ApiTester::ServerInformation.go(contract).size).to eq 0
  end

  it 'should generate a report if server is broadcasting its info' do
    stub_request(:get, url).to_return(body: "", status: 200, headers: {'Server' => 'A server'})
    expect(ApiTester::ServerInformation.go(contract).size).to eq 1
  end
end
