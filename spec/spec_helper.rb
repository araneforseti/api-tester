require 'rspec'
require 'require_all'
require "api-tester"
require 'webmock/rspec'
require_all "lib/**/*.rb"

# $LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)


RSpec.configure do |config|
  config.after(:each) do
    WebMock.reset!
  end
end
