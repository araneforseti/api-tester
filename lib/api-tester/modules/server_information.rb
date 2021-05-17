# frozen_string_literal: true

module ApiTester
  # Module for ensuring the server isn't broadcasting information about itself
  module ServerInformation
    def self.go(contract)
      reports = []
      endpoint = contract.endpoints[0]
      response = endpoint.default_call contract.base_url

      %i[server x_powered_by x_aspnetmvc_version x_aspnet_version].each do |key|
        if response.headers[key]
          reports << ServerBroadcastReport.new(response.headers[key],
                                               key)
        end
      end

      reports
    end

    def self.order
      10
    end
  end
end

# Report used by module
class ServerBroadcastReport
  attr_accessor :server_info, :server_key

  def initialize(server_info, server_key)
    self.server_info = server_info
    self.server_key = server_key
  end

  def print
    puts 'Found server information being broadcast in headers:'
    puts "   #{server_info}"
    puts "     as #{server_key}"
  end
end
