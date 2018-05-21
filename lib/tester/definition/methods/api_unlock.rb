require 'tester/util/supported_verbs'
require 'rest-client'
require 'tester/definition/methods/api_method'

class ApiUnlock < ApiMethod
  def call url, params={}, headers={}
    RestClient::Request.execute(method: :unlock, url: url, headers: headers)
  end

  def verb
    SupportedVerbs::UNLOCK
  end
end
