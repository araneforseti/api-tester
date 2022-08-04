# frozen_string_literal: true

module ApiTester
  # Class to define the whole contract
  class Contract
    attr_accessor :name, :endpoints, :base_url, :max_time, :required_headers

    def self.setup(name, base_url, max_time=500, &block)
      contract = new(name: name, base_url: base_url, max_time: max_time)
      contract.instance_eval(&block)
      contract
    end

    def initialize(name:, base_url:, max_time: 500)
      self.name = name
      self.endpoints = []
      self.base_url = base_url
      self.max_time = max_time
      self.required_headers = {}
    end

    def add_endpoint(endpoint)
      endpoints << endpoint
    end

    def with_endpoint(&block)
      endpoint = ApiTester::Endpoint.new(name: 'temp', relative_url: '')
      endpoint.instance_eval(&block)
      add_endpoint(endpoint)
    end

    def not_found_response=(response)
      @not_found = response
    end

    def bad_request_response=(response)
      @bad_request = response
    end
  end
end
