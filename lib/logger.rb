module ApiTester
  class Logger
    def initialize(stream = STDOUT)
      @stream = stream
    end

    def log(message = nil)
      @stream.puts message
    end
  end
end
