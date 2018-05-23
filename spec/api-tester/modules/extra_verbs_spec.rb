require 'api-tester/modules/extra_verbs'

describe ApiTester::ExtraVerbs do
  let(:url) {"www.example.com"}
  let(:bad_url) {"#{url}gibberishadsfasdf"}
  let(:endpoint) {ApiTester::Endpoint.new "Test", url}
  let(:contract) {ApiTester::Contract.new "Test"}
  let(:not_found) {ApiTester::Response.new 404}
  let(:not_allow) {ApiTester::Response.new 415}
  let(:contract) {ApiTester::Contract.new "Test"}
  let(:report) {ApiTester::ApiReport.new}

  before :each do
    endpoint.add_method ApiTester::SupportedVerbs::GET, ApiTester::Response.new(200)
    endpoint.not_allowed_response = not_allow
    endpoint.not_found_response = not_found
    contract.add_endpoint endpoint

    stub_request(:any, url).to_return(body: "", status: not_allow.code)
    stub_request(:get, url).to_return(body: "", status: 200)
    stub_request(:get, bad_url).to_return(body: "", status: not_found.code)
    stub_request(:delete, url).to_return(status: not_allow.code)
  end

  context 'verb not defined in definition responds' do
    it 'creates report if something other than the expected not allowed response is returned' do
      stub_request(:post, url).to_return(body: "", status: 100)
      expect(ApiTester::ExtraVerbs.go(contract).size).to eq 1
    end

    it 'creates no reports if the expected not allowed response is returned' do
      stub_request(:post, url).to_return(body: "", status: not_allow.code)
      expect(ApiTester::ExtraVerbs.go(contract).size).to eq 0
    end
  end

  context 'all verbs defined in definition' do
    it 'generates no reports' do
      endpoint.add_method ApiTester::SupportedVerbs::POST, ApiTester::Response.new, ApiTester::Request.new
      stub_request(:post, url).to_return(body: "", status: 200)
      expect(ApiTester::ExtraVerbs.go(contract).size).to eq 0
    end
  end

  context 'should use test helper' do
    before :each do
      test_helper_mock = Class.new(ApiTester::TestHelper) do
        def before
          RestClient.get("www.test.com/before")
        end

        def after
          RestClient.get("www.test.com/after")
        end
      end
      endpoint.test_helper = test_helper_mock.new
      stub_request(:get, "www.test.com/before").to_return(body: '', status: 200)
      stub_request(:get, "www.test.com/after").to_return(body: '', status: 200)
      expect(ApiTester::ExtraVerbs.go(contract).size).to eq 0
    end

    it 'should make use of test helper before method' do
      expect(a_request(:get, "www.test.com/before")).to have_been_made.at_least_once
    end

    it 'should make use of test helper after method' do
      expect(a_request(:get, "www.test.com/after")).to have_been_made.at_least_once
    end
  end
end
