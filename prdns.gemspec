
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "prdns/version"

Gem::Specification.new do |spec|
  spec.name          = "prdns"
  spec.version       = Prdns::VERSION
  spec.authors       = ["Arloan"]
  spec.email         = ["arloanxp@hotmail.com"]

  spec.summary       = %q{Purified DNS}
  spec.description   = %q{A DNS forward server offers correct results for both GFW polluted domains and CDN-enabled domains in China.}
  spec.homepage      = "https://github.com/arloan/prdns"

  spec.license       = 'GPL-3.0'
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'async-dns', "~> 1.2"
  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 13.0"

  spec.required_ruby_version = '>= 2.4.2'
end
