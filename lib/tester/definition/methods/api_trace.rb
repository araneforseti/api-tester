require 'tester/util/supported_verbs'
require 'rest-client'
require 'tester/definition/methods/api_method'

class ApiTrace < ApiMethod
  def call url, params={}, headers={}
    RestClient::Request.execute(method: :trace, url: url, headers: headers)
  end

  def verb
    SupportedVerbs::TRACE
  end
end
