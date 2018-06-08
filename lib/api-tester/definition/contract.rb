module ApiTester
  class Contract
    attr_accessor :name
    attr_accessor :endpoints
    attr_accessor :base_url

    def initialize name, base_url
      self.name = name
      self.endpoints = []
      self.base_url = base_url
    end

    def add_endpoint endpoint
      self.endpoints << endpoint
    end
  end
end
