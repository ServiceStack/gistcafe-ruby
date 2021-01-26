require_relative 'lib/gistcafe/version'

Gem::Specification.new do |spec|
  spec.name          = "gistcafe"
  spec.version       = Inspect::VERSION
  spec.authors       = ["ServiceStack, Inc."]
  spec.email         = ["team@servicestack.net"]

  spec.summary       = "gist.cafe utils for Ruby"
  spec.homepage      = "https://gist.cafe"
  spec.license       = "BSD 2-Clause"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  #spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/ServiceStack/gistcafe-ruby"
  spec.metadata["changelog_uri"] = "https://github.com/ServiceStack/gistcafe-ruby/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
