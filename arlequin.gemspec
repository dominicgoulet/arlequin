# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name        = "arlequin"
  s.version     = "0.1.1"
  s.summary     = "Arlequin performance logger gem"
  s.description = "Performance Logger Gem"
  s.authors     = [ "Dominic Goulet" ]
  s.email       = "dominic.goulet@gmail.com"
  s.files       = Dir["lib/**/*"]
  s.homepage    = "https://rubygems.org/gems/arlequin"
  s.license     = "MIT"
  s.homepage    = "https://github.com/dominicgoulet/arlequin"

  s.add_dependency "rails", ">= 5.0"
end
