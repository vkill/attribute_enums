# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "attribute_enums/version"

Gem::Specification.new do |s|
  s.name        = "attribute_enums"
  s.version     = AttributeEnums::VERSION
  s.authors     = ["vkill"]
  s.email       = ["vkill.net@gmail.com"]
  s.homepage    = "https://github.com/vkill/attribute_enums"
  s.summary     = "A model attribute enums plugin for Rails3. like 'symbolize' gem."
  s.description = "A model attribute enums plugin for Rails3. like 'symbolize' gem."

  s.rubyforge_project = "attribute_enums"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency 'bundler'
  s.add_development_dependency "rake"
  s.add_development_dependency "rspec"
  s.add_development_dependency "guard-rspec"

  s.add_development_dependency "rails", "~> 3.0"
  s.add_development_dependency "sqlite3-ruby"
  s.add_development_dependency "rspec-rails", "~> 2.7.0"
  s.add_development_dependency "capybara"
  s.add_development_dependency "timecop"
  s.add_development_dependency "pry"
  s.add_development_dependency "pry-padrino"

  s.add_dependency "activerecord", "~> 3.0"
  s.add_dependency "activesupport", "~> 3.0"
end

