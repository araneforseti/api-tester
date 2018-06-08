require 'pry'

module ApiTester
  module ServerInformation
    def self.go contract
      reports = []
      endpoint = contract.endpoints[0]
      response = endpoint.default_call contract.base_url

      [:server, :x_powered_by, :x_aspnetmvc_version, :x_aspnet_version].each do |server_key|
        if response.headers[server_key] then
          reports << ServerBroadcastReport.new(response.headers[server_key], server_key)
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
  attr_accessor :server_key

  def initialize server_info, server_key
    self.server_info = server_info
    self.server_key = server_key
  end

  def print
    puts "Found server information being broadcast in headers:"
    puts "   #{self.server_info}"
    puts "     as #{self.server_key}"
  end
end
