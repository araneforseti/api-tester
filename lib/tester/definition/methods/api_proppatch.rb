require 'tester/util/supported_verbs'
require 'rest-client'
require 'tester/definition/methods/api_method'

class ApiProppatch < ApiMethod
  def call url, params={}, headers={}
    RestClient::Request.execute(method: :proppatch, url: url, headers: headers)
  end

  def verb
    SupportedVerbs::PROPPATCH
  end
end
