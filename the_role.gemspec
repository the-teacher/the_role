# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "the_role/version"

Gem::Specification.new do |s|
  s.name        = "the_role"
  s.version     = TheRole::VERSION
  s.authors     = ["Ilya N. Zykin [the-teacher]"]
  s.email       = ["zykin-ilya@ya.ru"]
  s.homepage    = "https://github.com/the-teacher/the_role"
  s.summary     = %q{Authorization for Rails 4}
  s.description = %q{Authorization gem for Ruby on Rails with Management Panel}

  s.rubyforge_project = "the_role"

  s.files         = `git ls-files`.split("\n").select{ |file_name| !(file_name =~ /^spec/) }
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency 'the_role_api', '~> 3.0.1'
  s.add_runtime_dependency 'the_role_management_panel', '~> 3.0.1'
end
