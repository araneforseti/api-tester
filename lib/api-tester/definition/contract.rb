module ApiTester
  class Contract
    attr_accessor :name
    attr_accessor :endpoints

    def initialize name
      self.name = name
      self.endpoints = []
    end

    def add_endpoint endpoint
      self.endpoints << endpoint
    end
  end
end
