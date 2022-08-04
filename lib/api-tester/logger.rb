module ApiTester
  class Logger
    def initialize(stream = $stdout)
      @stream = stream
    end

    def log(message = nil)
      @stream.puts message
    end
  end
end
