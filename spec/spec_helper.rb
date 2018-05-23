$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "api-tester"
require 'webmock/rspec'
require 'rspec'

RSpec.configure do |config|
  config.after(:each) do
    WebMock.reset!
  end
end
