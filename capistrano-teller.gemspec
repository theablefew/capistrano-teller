# frozen_string_literal: true

require_relative "lib/capistrano/teller/version"

Gem::Specification.new do |spec|
  spec.name = "capistrano-teller"
  spec.version = Capistrano::Teller::VERSION
  spec.authors = ["Spencer Markowski"]
  spec.email = ["spencer.markowski@gmail.com"]

  spec.summary = "Capistrano plugin for managing environment variables with teller"
  spec.description = "Capistrano plugin for managing environment variables with teller"
  spec.homepage = "https://github.com/theablefew/capistrano-teller"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["homepage_uri"] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  spec.add_dependency "zeitwerk", "~> 2.0"
  spec.add_dependency "capistrano", "~> 3.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
