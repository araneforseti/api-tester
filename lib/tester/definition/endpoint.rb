require 'tester/definition/response'
require 'tester/definition/api_method'

class Endpoint
  attr_accessor :name
  attr_accessor :base_url
  attr_accessor :path_params
  attr_accessor :methods
  attr_accessor :test_helper
  attr_accessor :bad_request_response
  attr_accessor :not_allowed_response
  attr_accessor :not_found_response

  def initialize name, url
    self.base_url = url
    self.name = name
    self.methods = []
    self.path_params = []
    self.test_helper = TestHelper.new
    self.bad_request_response = Response.new 400
    self.not_allowed_response = Response.new 415
    self.not_found_response = Response.new 404
  end

  def url
    temp_url = self.base_url
    self.path_params.each do |param|
      temp_url.sub! "{#{param}}", self.test_helper.retrieve_param(param)
    end
    temp_url
  end

  def call method, payload={}, headers={}
    self.test_helper.before
    begin      
      response = RestClient::Request.execute(method: method.verb, url: self.url, payload: payload, headers: headers)
    rescue RestClient::ExceptionWithResponse => e
      response = e.response
    end
    self.test_helper.after
    response
  end

  def add_method verb, response, request=Request.new()
    self.methods << ApiMethod.new(verb, response, request)
    self
  end

  def add_path_param param
    self.path_params << param
    self
  end

  def verbs
    self.methods.map(&:verb)
  end
end
