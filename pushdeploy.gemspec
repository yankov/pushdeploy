# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "pushdeploy/version"

Gem::Specification.new do |s|
  s.name        = "pushdeploy"
  s.version     = Pushdeploy::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Artem Yankov"]
  s.email       = ["artem.yankov@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Easy deployment after 'git push' for Ruby applications}
  s.description = %q{Automatically deploys application after 'git push' and run specified commands like 'bundle install'  and 'rake db:migrate'}

  s.rubyforge_project = "pushdeploy"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
