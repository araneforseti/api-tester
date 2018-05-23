require 'webmock/rspec'

describe ApiTester::Endpoint do
  let(:endpoint) {ApiTester::Endpoint.new "test", "test.com"}

  context 'verbs' do
    it 'should empty array with no added verbs' do
      expect(endpoint.verbs).to eq []
    end

    it 'should return the verbs in supported methods' do
      endpoint.add_method ApiTester::SupportedVerbs::GET, ApiTester::Response.new, ApiTester::Request.new
      endpoint.add_method ApiTester::SupportedVerbs::POST, ApiTester::Response.new, ApiTester::Request.new
      expect(endpoint.verbs).to eq [ApiTester::SupportedVerbs::GET, ApiTester::SupportedVerbs::POST]
    end
  end

  context 'call' do
    it 'should call out with specified verb' do
      stub_request(:get, "test.com").to_return(body: "response happened", status: 200)
      response = endpoint.call ApiTester::Method.new(ApiTester::SupportedVerbs::GET, ApiTester::Response.new, ApiTester::Request.new), {}, {}
      expect(response.code).to eq 200
      expect(response.body).to eq "response happened"
    end
  end

  context 'url' do
    it 'should replace path params' do
      endpoint = ApiTester::Endpoint.new "test path param", "test.com/{paramKey}"
      endpoint.add_path_param "paramKey"
      endpoint.test_helper = ParamTestHelper.new
      expect(endpoint.url).to eq "test.com/paramValue"
    end

    it 'should make no changes when no path params' do
      expect(endpoint.url).to eq "test.com"
    end
  end
end

class ParamTestHelper
  def retrieve_param something
    {"paramKey" => "paramValue"}[something]
  end
end
