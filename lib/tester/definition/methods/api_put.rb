require 'rest-client'
require 'tester/definition/methods/api_method'

class ApiPut < ApiMethod
  def put url, json_payload, headers
    RestClient.put(url, json_payload, headers)  { |real_response, request, result|
      real_response
    }
  end

  def call url, body_params={}, request_params={}
    self.put url, body_params.to_json, request_params
  end

  def verb
    SupportedVerbs::PUT
  end
end
