lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "cheepub/version"

Gem::Specification.new do |spec|
  spec.name          = "cheepub"
  spec.version       = Cheepub::VERSION
  spec.authors       = ["takahashim"]
  spec.email         = ["maki@rubycolor.org"]

  spec.summary       = "Simple EPUB generator from Markdown"
  spec.description   = %q{Simple EPUB generator from Markdown. Inspired by denden converter}
  spec.homepage      = "https://github.com/takahashim/cheepub"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "gepub", "~> 0.7"
  spec.add_dependency "kramdown", "~> 1.16"
  spec.add_dependency "clamp", "~> 1.2"
  spec.add_dependency "oga", "~> 2.15"
  spec.add_dependency "coderay"
  spec.add_dependency "rouge"
  spec.add_dependency "rb_latex", "~> 0.1.3"

  spec.add_development_dependency "rufo", "~> 0.3"
  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 12.0"
  spec.add_development_dependency "test-unit", "~> 3.2"
  spec.add_development_dependency "test-unit-notify"
  spec.add_development_dependency "terminal-notifier"
end
