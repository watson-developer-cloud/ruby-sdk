
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "watson_developer_cloud/version"
require "rake"

Gem::Specification.new do |spec|
  spec.name          = "watson_developer_cloud"
  spec.version       = WatsonDeveloperCloud::VERSION
  spec.authors       = ["Author"]
  # spec.email         = ["TODO: Write your email address"]

  spec.summary       = %q{Summary}
  # spec.description   = %q{TODO: Write a longer description or delete this line.}
  # spec.homepage      = "TODO: Put your gem's website or public repo URL here."

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = FileList["lib/*.rb", "lib/watson_developer_cloud/*.rb", "bin/*", "test/**/*"].to_a
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

 
  spec.add_runtime_dependency "eventmachine", "~> 1.2.7"
  spec.add_runtime_dependency "faye-websocket", "~> 0.10.7"
  spec.add_runtime_dependency "http", "~> 3.3.0"
  spec.add_runtime_dependency "json", "~> 2.1.0"

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "codecov", "~> 0.1.10"
  spec.add_development_dependency "dotenv", "~> 2.4.0"
  spec.add_development_dependency "httplog", "~> 1.0.3"
  spec.add_development_dependency "minitest", "~> 5.11.3"
  spec.add_development_dependency "minitest-hooks", "~> 1.5.0"
  spec.add_development_dependency "rake", "~> 12.3.1"
  spec.add_development_dependency "simplecov", "~> 0.16.1"
  spec.add_development_dependency "webmock", "~> 3.4.2"
end
