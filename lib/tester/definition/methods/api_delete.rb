require 'tester/util/supported_verbs'
require 'rest-client'
require 'tester/definition/methods/api_method'

class ApiDelete < ApiMethod
  def call url, params={}, headers={}
    RestClient::Request.execute(method: :delete, url: url, headers: headers)
  end

  def verb
    SupportedVerbs::DELETE
  end
end
