require 'tester/util/supported_verbs'
require 'rest-client'
require 'tester/definition/methods/api_method'

class ApiMove < ApiMethod
  def call url, params={}, headers={}
    RestClient::Request.execute(method: :move, url: url, headers: headers)
  end

  def verb
    SupportedVerbs::MOVE
  end
end
