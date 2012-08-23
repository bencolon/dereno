# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "dereno/version"

Gem::Specification.new do |s|
  s.name        = "dereno"
  s.version     = Dereno::VERSION
  s.authors     = ["Ben Colon", "Axel Vergult"]
  s.email       = ["ben@official.fm", "axel@official.fm"]
  s.homepage    = "http://official.fm"
  s.summary     = %q{Deployments release notes for Rails project using Git}
  s.description = %q{Deployments release notes sent via email with Git commits / Pivotal Tracker stories and Campfire notification.}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency 'capistrano'
  s.add_dependency 'pivotal-tracker'
  s.add_dependency 'pony'
  s.add_dependency 'tinder'
  s.add_dependency 'activesupport'

  s.add_development_dependency 'rake'
  s.add_development_dependency 'mocha'

end
