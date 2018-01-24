# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pg/pglogical/version'

Gem::Specification.new do |spec|
  spec.name          = "pg-pglogical"
  spec.version       = PG::Pglogical::VERSION
  spec.authors       = ["Nick Carboni"]
  spec.email         = ["ncarboni@redhat.com"]

  spec.summary       = "A ruby gem for configuring and using pglogical"
  spec.description   = <<-EOS
This gem provides a class with methods which map directly to the SQL stored
procedure APIs provided by pglogical. It also provides a way to mix these
methods directly into the ActiveRecord connection object.
EOS
  spec.homepage      = "https://github.com/ManageIQ/pg-pglogical"
  spec.license       = "Apache-2.0"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "activerecord"
  spec.add_dependency "pg", "~> 0.18"

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rubocop", "~> 0.52"
end
