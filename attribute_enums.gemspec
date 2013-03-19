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

  s.add_development_dependency "activerecord"
  s.add_development_dependency "sqlite3"
  s.add_development_dependency "i18n"
  s.add_development_dependency "rspec"
  s.add_development_dependency 'pry'
  
end
