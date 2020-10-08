# frozen_string_literal: true

module ApiTester
  # Interface for when things need to be done before or after an api call
  class TestHelper
    def before; end

    def retrieve_param(key); end

    def after; end
  end
end
