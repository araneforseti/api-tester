module ApiTester
  class Runner
    def initialize(paths:)
      @paths = paths
    end

    def run
      @paths.each do |path|
        load path
      end

      ApiTester.run
    end
  end
end
