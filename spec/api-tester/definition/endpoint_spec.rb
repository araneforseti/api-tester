require 'webmock/rspec'

describe ApiTester::Endpoint do
  let(:base_url) { '' }
  let(:endpoint) { ApiTester::Endpoint.new name: 'test', relative_url: 'test.com' }

  context 'verbs' do
    it 'should empty array with no added verbs' do
      expect(endpoint.verbs).to eq []
    end

    it 'should return the verbs in supported methods' do
      endpoint.add_method verb: ApiTester::SupportedVerbs::GET,
                          response: ApiTester::Response.new,
                          request: ApiTester::Request.new
      endpoint.add_method verb: ApiTester::SupportedVerbs::POST,
                          response: ApiTester::Response.new,
                          request: ApiTester::Request.new
      expect(endpoint.verbs).to eq [ApiTester::SupportedVerbs::GET,
                                    ApiTester::SupportedVerbs::POST]
    end
  end

  context 'call' do
    it 'should call out with specified verb' do
      stub_request(:get, 'test.com').to_return(body: 'response happened',
                                               status: 200)
      method = ApiTester::Method.new verb: ApiTester::SupportedVerbs::GET,
                                     response: ApiTester::Response.new,
                                     request: ApiTester::Request.new
      response = endpoint.call base_url: base_url,
                               method: method,
                               payload: {},
                               headers: {}
      expect(response.code).to eq 200
      expect(response.body).to eq 'response happened'
    end

    it 'should use specified query string' do
      stub_request(:get,
                   'test.com?query=hello').to_return(body: 'response happened',
                                                     status: 200)
      method = ApiTester::Method.new verb: ApiTester::SupportedVerbs::GET,
                                     response: ApiTester::Response.new,
                                     request: ApiTester::Request.new
      response = endpoint.call base_url: base_url,
                               method: method,
                               query: 'query=hello',
                               payload: {},
                               headers: {}
      expect(response.code).to eq 200
      expect(response.body).to eq 'response happened'
    end
  end

  context 'url' do
    it 'should replace path params' do
      endpoint = ApiTester::Endpoint.new name: 'test path param',
                                         relative_url: 'test.com/{paramKey}'
      endpoint.add_path_param 'paramKey'
      endpoint.test_helper = ParamTestHelper.new
      expect(endpoint.url).to eq 'test.com/paramValue'
    end

    it 'should make no changes when no path params' do
      expect(endpoint.url).to eq 'test.com'
    end
  end
end

class ParamTestHelper
  def retrieve_param(something)
    { 'paramKey' => 'paramValue' }[something]
  end
end
