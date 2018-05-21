require 'rest-client'
require 'tester/definition/methods/api_method'

class ApiHead < ApiMethod
  def call url, params={}, headers={}
    headers[:params] = params

    RestClient.head(url, headers)  { |real_response, request, result|
      real_response
    }
  end

  def verb
    SupportedVerbs::HEAD
  end
end
