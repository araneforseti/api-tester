module ApiTester
  module ServerInformation
    def self.go contract
      reports = []
      endpoint = contract.endpoints[0]
      response = endpoint.default_call

      if response.headers[:server] then
        reports << ServerBroadcastReport.new(response.headers[:server])
      end

      reports
    end

    def self.order
      10
    end
  end
end

class ServerBroadcastReport
  attr_accessor :server_info

  def initialize server_info
    self.server_info = server_info
  end

  def print
    puts "Found server information being broadcast in headers:"
    puts "   #{self.server_info}"
  end
end
