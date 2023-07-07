lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fastlane/plugin/notion_release_notes/version'

Gem::Specification.new do |spec|
  spec.name          = 'fastlane-plugin-notion_release_notes'
  spec.version       = Fastlane::NotionReleaseNotes::VERSION
  spec.author        = 'Gustavo Fernandes'
  spec.email         = 'gustavofernandes@vivaweb.net'

  spec.summary       = 'Fetches tasks from notion database and assembles release notes in markdown format'
  # spec.homepage      = "https://github.com/<GITHUB_USERNAME>/fastlane-plugin-notion_release_notes"
  spec.license       = "MIT"

  spec.files         = Dir["lib/**/*"] + %w(README.md LICENSE)
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.6'

  # Don't add a dependency to fastlane or fastlane_re
  # since this would cause a circular dependency

  spec.add_dependency 'notion-ruby-client', '~> 1.0.0'

  spec.add_development_dependency('bundler')
  spec.add_development_dependency('fastlane', '>= 2.213.0')
  spec.add_development_dependency('pry')
  spec.add_development_dependency('rake')
  spec.add_development_dependency('rspec')
  spec.add_development_dependency('rspec_junit_formatter')
  spec.add_development_dependency('rubocop', '1.12.1')
  spec.add_development_dependency('rubocop-performance')
  spec.add_development_dependency('rubocop-require_tools')
  spec.add_development_dependency('simplecov')
end
