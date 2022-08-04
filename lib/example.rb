module ApiTester
  class Example
    Result = Struct.new(:status, :message)

    def initialize(description, &block)
      @description = description
      @block = block
    end

    def run(world)
      world.instance_eval(&block)
      return Result.new(:pass)
    rescue => message
      return Result.new(:fail, message)
    end
  end
end
