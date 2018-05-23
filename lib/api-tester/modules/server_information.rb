require 'pry'

module ApiTester
  module ServerInformation
    def self.go contract
      reports = []
      endpoint = contract.endpoints[0]
      response = endpoint.default_call

      [:server, :x_powered_by, :x_aspnetmvc_version, :x_aspnet_version].each do |server_key|
        if response.headers[server_key] then
          reports << ServerBroadcastReport.new(response.headers[server_key])
        end
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
