# frozen_string_literal: true

module ApiTester
  # Holds data necessary for tests
  class BoundaryCase
    attr_accessor :payload, :headers, :description

    def initialize(description:, payload:, headers:)
      self.description = description
      self.payload = payload
      self.headers = headers
    end
  end
end
