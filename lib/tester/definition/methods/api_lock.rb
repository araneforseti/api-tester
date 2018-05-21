require 'tester/util/supported_verbs'
require 'rest-client'
require 'tester/definition/methods/api_method'

class ApiLock < ApiMethod
  def call url, params={}, headers={}
    RestClient::Request.execute(method: :lock, url: url, headers: headers)
  end

  def verb
    SupportedVerbs::LOCK
  end
end
