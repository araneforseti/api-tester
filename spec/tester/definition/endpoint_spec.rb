require 'webmock/rspec'

describe Endpoint do
  let(:endpoint) {Endpoint.new "test", "test.com"}

  context 'verbs' do
    it 'should empty array with no added verbs' do
      expect(endpoint.verbs).to eq []
    end

    it 'should return the verbs in supported methods' do
      endpoint.add_method SupportedVerbs::GET, Response.new, Request.new
      endpoint.add_method SupportedVerbs::POST, Response.new, Request.new
      expect(endpoint.verbs).to eq [SupportedVerbs::GET, SupportedVerbs::POST]
    end
  end

  context 'call' do
    it 'should call out with specified verb' do
      stub_request(:get, "test.com").to_return(body: "response happened", status: 200)
      response = endpoint.call ApiMethod.new(SupportedVerbs::GET, Response.new, Request.new), {}, {}
      expect(response.code).to eq 200
      expect(response.body).to eq "response happened"
    end
  end
end
