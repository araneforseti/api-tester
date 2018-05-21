require 'tester/util/supported_verbs'
require 'rest-client'
require 'tester/definition/methods/api_method'

class ApiCopy < ApiMethod
  def call url, params={}, headers={}
    RestClient::Request.execute(method: :copy, url: url, headers: headers)
  end

  def verb
    SupportedVerbs::COPY
  end
end
