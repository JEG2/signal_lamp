require_relative "lib/signal_lamp/version"

Gem::Specification.new do |spec|
  spec.name          = "Signal Lamp"
  spec.version       = SignalLamp::VERSION
  spec.authors       = ["James Edward Gray II (JEG2)"]
  spec.email         = %w[james@graysoftinc.com]
  spec.summary       = "A simple tool for decoupling Ruby object systems."
  spec.description   = <<END_DESCRIPTION
This is a system for decoupling objects. Some objects become "signalers" that
tell anyone who is interested when "events" happen. Other objects act as
"watchers" waiting for and acting on those events.
END_DESCRIPTION
  spec.homepage      = "https://github.com/JEG2/signal_lamp"
  spec.license       = "MIT"

  spec.files            = `git ls-files -z`.split("\x0")
  spec.test_files       = spec.files.grep(%r{\Aspec/})
  spec.extra_rdoc_files = %w[README.md]
  spec.rdoc_options    << "--main" << "README.md"
  spec.require_paths    = %w[lib]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake",    "~> 10.3"
  spec.add_development_dependency "rspec",   "~> 2.14"
  spec.add_development_dependency "ZenTest", "~> 4.10"
  spec.add_development_dependency "rdoc",    "~> 4.1"
end
