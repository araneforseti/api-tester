module ApiTester
  class Example
    Result = Struct.new(:status, :message)

    def initialize(description, &block)
      @description = description
      @block = block
    end

    def run(world)
      world.instance_eval(&@block)
      Result.new(:pass)
    rescue StandardError => e
      Result.new(:fail, e)
    end
  end
end
