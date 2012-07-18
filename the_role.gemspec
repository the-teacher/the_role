# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "the_role/version"

Gem::Specification.new do |s|
  s.name        = "the_role"
  s.version     = TheRole::VERSION
  s.authors     = ["Ilya N. Zykin"]
  s.email       = ["zykin-ilya@ya.ru"]
  s.homepage    = "https://github.com/the-teacher/the_role"
  s.summary     = %q{Authorization lib for Rails 3 with Web Interface, aka CanCan killer}
  s.description = %q{Authorization lib for Rails 3 with Web Interface, aka CanCan killer}

  s.rubyforge_project = "the_role"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  
  s.add_dependency 'haml'
  s.add_dependency 'sass'
  s.add_dependency 'sass-rails'
  s.add_dependency 'coffee-rails'
  # less for tw bootstrap 
  s.add_dependency 'therubyracer'
  s.add_dependency 'less-rails'
end
