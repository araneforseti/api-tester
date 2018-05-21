require 'tester/util/supported_verbs'
require 'rest-client'
require 'tester/definition/methods/api_method'

class ApiPropfind < ApiMethod
  def call url, params={}, headers={}
    RestClient::Request.execute(method: :propfind, url: url, headers: headers)
  end

  def verb
    SupportedVerbs::PROPFIND
  end
end
