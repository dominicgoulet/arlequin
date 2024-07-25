# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name        = "arlequin"
  s.version     = "0.1.2"
  s.summary     = "Arlequin performance logger gem"
  s.description = "Performance Logger Gem"

  s.license     = "MIT"

  s.author      = "Dominic Goulet"
  s.email       = "dominic@dominicgoulet.com"
  s.homepage    = "https://github.com/dominicgoulet/arlequin"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  s.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|translation)/}) }
  end

  s.metadata = {
    "source_code_uri" => s.homepage
  }

  s.add_dependency "rails", ">= 5.0"
end
