require 'rest-client'
require 'tester/definition/methods/api_method'

class ApiPost < ApiMethod
  def post url, json_payload, headers
    RestClient.post(url, json_payload, headers)  { |real_response, request, result|
      real_response
    }
  end

  def call url, body_params={}, request_params={}
    post url, body_params.to_json, request_params
  end

  def verb
    SupportedVerbs::POST
  end
end
