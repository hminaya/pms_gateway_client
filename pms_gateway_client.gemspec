# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pms_gateway_client/version'

Gem::Specification.new do |spec|
  spec.name          = "pms_gateway_client"
  spec.version       = PmsGatewayClient::VERSION
  spec.authors       = ["Forrest Chang"]
  spec.email         = ["fkc_email-ruby@yahoo.com"]
  spec.description   = %q{PMS gateway client}
  spec.summary       = %q{PMS gateway client}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "curb"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 2.6"

end
