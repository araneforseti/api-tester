module ApiTester
  class CLI
    def parse(items = ARGV)
      config = Slop.parse(items)
      run(config)
    end

    private

    def run(options)
      paths = Set.new
      options.arguments.each do |argument|
        Find.find(argument) do |path|
          paths << path if path.match?(/\A(.*).rb\Z/)
        end
      end
      Runner.new(paths: paths).run
    end
  end
end
