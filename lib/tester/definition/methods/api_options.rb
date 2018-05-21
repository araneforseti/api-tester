require 'rest-client'
require 'tester/definition/methods/api_method'

class ApiOptions < ApiMethod
  def call url, params={}, headers={}
    headers[:params] = params

    RestClient.options(url, headers)  { |real_response, request, result|
      real_response
    }
  end

  def verb
    SupportedVerbs::OPTIONS
  end
end
