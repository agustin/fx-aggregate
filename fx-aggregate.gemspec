require_relative "lib/fx-aggregate/version"

Gem::Specification.new do |spec|
  spec.name = "fx-aggregate"
  spec.version = FxAggregate::VERSION
  spec.authors = ["Agustin"]
  spec.email = ["agustin@mailbutler.io"]

  spec.summary = "An extension for the fx gem to manage PostgreSQL aggregate functions in Rails migrations."
  spec.description = <<~DESCRIPTION
    Adds methods to ActiveRecord::Migration to create and manage database aggregates
    functions in Rails
  DESCRIPTION
  spec.homepage = "https://github.com/agustin/fx-aggregate"
  spec.license = "MIT"

  spec.required_ruby_version = Gem::Requirement.new(">= 2.7.0")

  spec.metadata = {
    "bug_tracker_uri" => "#{spec.homepage}/issues",
    "changelog_uri" => "#{spec.homepage}/blob/v#{spec.version}/CHANGELOG.md",
    "homepage_uri" => spec.homepage,
    "source_code_uri" => spec.homepage
  }

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path("..", __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.require_paths = ["lib"]

  spec.add_dependency "fx", ">= 0.9"
end
