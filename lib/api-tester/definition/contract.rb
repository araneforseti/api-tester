# frozen_string_literal: true

module ApiTester
  # Class to define the whole contract
  class Contract
    attr_accessor :name, :endpoints, :base_url, :max_time

    def initialize(name:, base_url:, max_time: 500)
      self.name = name
      self.endpoints = []
      self.base_url = base_url
      self.max_time = max_time
    end

    def add_endpoint(endpoint)
      endpoints << endpoint
    end
  end
end
