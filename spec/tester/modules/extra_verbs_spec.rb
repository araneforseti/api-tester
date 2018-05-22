require 'tester/modules/extra_verbs'

describe ExtraVerbs do
  let(:url) {"www.example.com"}
  let(:bad_url) {"#{url}gibberishadsfasdf"}
  let(:endpoint) {Endpoint.new "Test", url}
  let(:not_found) {Response.new 404}
  let(:not_allow) {Response.new 415}
  let(:report) {ApiReport.new}

  let(:extra_verbs) {ExtraVerbs.new}

  before :each do
    endpoint.add_method SupportedVerbs::GET, Response.new(200)
    endpoint.not_allowed_response = not_allow
    endpoint.not_found_response = not_found

    stub_request(:any, url).to_return(body: "", status: not_allow.code)
    stub_request(:get, url).to_return(body: "", status: 200)
    stub_request(:get, bad_url).to_return(body: "", status: not_found.code)
    stub_request(:delete, url).to_return(status: not_allow.code)
  end

  context 'verb not defined in definition responds' do
    it 'fails if something other than the expected not allowed response is returned' do
      stub_request(:post, url).to_return(body: "", status: 100)
      expect(extra_verbs.go(endpoint, report)).to be false
    end

    it 'passes if the expected not allowed response is returned' do
      stub_request(:post, url).to_return(body: "", status: not_allow.code)
      expect(extra_verbs.go(endpoint, report)).to be true
    end
  end

  context 'all verbs defined in definition' do
    it 'passes' do
      endpoint.add_method SupportedVerbs::POST, Response.new, Request.new
      stub_request(:post, url).to_return(body: "", status: 200)
      expect(extra_verbs.go(endpoint, report)).to be true
    end
  end

  context 'should use test helper' do
    before :each do
      test_helper_mock = Class.new(TestHelper) do
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
      expect(extra_verbs.go(endpoint, report)).to be true
    end

    it 'should make use of test helper before method' do
      expect(a_request(:get, "www.test.com/before")).to have_been_made.at_least_once
    end

    it 'should make use of test helper after method' do
      expect(a_request(:get, "www.test.com/after")).to have_been_made.at_least_once
    end
  end
end
