module ApiTester
  class Formatter
    def initialize(logger)
      @logger = logger
    end

    def record(example, result)
      message =
        case result.status
        when :pass then "[PASS] #{example.description}"
        when :fail then "[FAIL] #{example.description} #{result.message}"
        end

      @logger.log(message)
    end

    def context(context)
      @logger.log(context.description)
      yield
    end
  end
end
