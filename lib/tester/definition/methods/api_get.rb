require 'rest-client'
require 'tester/definition/methods/api_method'

class ApiGet < ApiMethod
  def call url, params={}, headers={}
    headers[:params] = params

    RestClient.get(url, headers)  { |real_response, request, result|
      real_response
    }
  end

  def verb
    SupportedVerbs::GET
  end
end
