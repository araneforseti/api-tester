require 'tester/util/supported_verbs'
require 'rest-client'
require 'tester/definition/methods/api_method'

class ApiMkcol < ApiMethod
  def call url, params={}, headers={}
    RestClient::Request.execute(method: :mkcol, url: url, headers: headers)
  end

  def verb
    SupportedVerbs::MKCOL
  end
end
