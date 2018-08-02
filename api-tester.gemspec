# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'api-tester/version'

Gem::Specification.new do |spec|
  spec.name          = 'api-tester'
  spec.version       = ApiTester::VERSION
  spec.authors       = ['arane']
  spec.email         = ['arane9@gmail.com']

  spec.summary       = 'Tool to help test APIs'
  spec.description   = 'Tool to test APIs which will eventually do boundary testing and other sorts of testing automatically given a contract'
  spec.homepage      = 'https://github.com/araneforseti/api-tester'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'https://rubygems.org/'
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.13'
  spec.add_development_dependency 'bundler-audit', '~>0.6.0'
  spec.add_development_dependency 'guard-rspec', '~> 4.7.3'
  spec.add_development_dependency 'pry', '~> 0.11'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'require_all', '~>2.0.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 0.58.2'
  spec.add_development_dependency 'terminal-notifier', '~> 2.0.0'
  spec.add_development_dependency 'terminal-notifier-guard', '~> 1.6.0'
  spec.add_development_dependency 'webmock', '~> 3.4'

  spec.add_runtime_dependency 'injection_vulnerability_library', '0.0.2'
  spec.add_runtime_dependency 'rest-client', '~> 2.0'
end
