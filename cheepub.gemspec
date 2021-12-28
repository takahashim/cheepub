lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "cheepub/version"

Gem::Specification.new do |spec|
  spec.name          = "cheepub"
  spec.version       = Cheepub::VERSION
  spec.authors       = ["takahashim"]
  spec.email         = ["maki@rubycolor.org"]

  spec.summary       = "Simple EPUB/PDF generator from Markdown"
  spec.description   = %q{Simple EPUB/PDF generator from Markdown. Inspired by denden converter}
  spec.homepage      = "https://github.com/takahashim/cheepub"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "gepub"
  spec.add_dependency "kramdown"
  spec.add_dependency "kramdown-parser-gfm"
  spec.add_dependency "clamp"
  spec.add_dependency "oga"
  spec.add_dependency "coderay"
  spec.add_dependency "rouge"
  spec.add_dependency "rb_latex"

  spec.add_development_dependency "rufo"
  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "test-unit", "~> 3.2"
  spec.add_development_dependency "test-unit-notify"
  spec.add_development_dependency "terminal-notifier"
end
