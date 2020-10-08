# frozen_string_literal: true

module ApiTester
  # Class to define the whole contract
  class Contract
    attr_accessor :name
    attr_accessor :endpoints
    attr_accessor :base_url

    def initialize(name:, base_url:)
      self.name = name
      self.endpoints = []
      self.base_url = base_url
    end

    def add_endpoint(endpoint)
      endpoints << endpoint
    end
  end
end
