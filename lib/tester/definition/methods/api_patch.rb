require 'rest-client'
require 'tester/definition/methods/api_method'

class ApiPatch < ApiMethod
  def patch url, json_payload, headers
    RestClient.patch(url, json_payload, headers)  { |real_response, request, result|
      real_response
    }
  end

  def call url, body_params={}, request_params={}
    patch url, body_params.to_json, request_params
  end

  def verb
    SupportedVerbs::PATCH
  end
end
