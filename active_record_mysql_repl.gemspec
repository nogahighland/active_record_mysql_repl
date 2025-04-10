# frozen_string_literal: true

require_relative "lib/active_record_mysql_repl/version"

Gem::Specification.new do |spec|
  spec.name = "active_record_mysql_repl"
  spec.version = ActiveRecordMysqlRepl::VERSION
  spec.authors = ["Hiroki Kishi"]
  spec.email = ["noga.highland@gmail.com"]

  spec.summary = "MySQL REPL featured by ActiveRecord and Pry"
  spec.description = "MySQL REPL featured by ActiveRecord and Pry"
  spec.homepage = "https://github.com/nogahighland/active_record_mysql_repl"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = `git ls-files`.split("\n").reject do |f|
    (f == gemspec) ||
      f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "byebug", "~>11.1.3"
  spec.add_development_dependency "solargraph", "~>0.50.0"
  spec.add_development_dependency "standard"

  spec.add_dependency "activerecord", "~> 7.1"
  spec.add_dependency "activesupport", "~>7.2"
  spec.add_dependency "awesome_print", "~> 1.9"
  spec.add_dependency "clipboard", "~> 2.0"
  spec.add_dependency "colorize", "~> 1.1"
  spec.add_dependency "csv", "~> 3.3.0"
  spec.add_dependency "mysql2", "~> 0.5.6"
  spec.add_dependency "net-ssh", "~> 7.3"
  spec.add_dependency "net-ssh-gateway", "~> 2.0"
  spec.add_dependency "pry", "~> 0.14.2"
  spec.add_dependency "rails-erd", "~> 1.7"
  spec.add_dependency "terminal-table", "~> 3.0"
  spec.add_dependency "ed25519", "~> 1.3"
  spec.add_dependency "bcrypt_pbkdf", "~> 1.1"
end
