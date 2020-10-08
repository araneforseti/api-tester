# frozen_string_literal: true

require 'rspec'
require 'require_all'
require 'api-tester'
require 'webmock/rspec'
require_all 'lib/**/*.rb'

RSpec.configure do |config|
  config.after(:each) do
    WebMock.reset!
  end
end
