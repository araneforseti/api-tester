module ApiTester
  # Holds data necessary for tests
  class BoundaryCase
    attr_accessor :payload
    attr_accessor :headers
    attr_accessor :description

    def initialize(description, payload, headers)
      self.description = description
      self.payload = payload
      self.headers = headers
    end
  end
end
