# frozen_string_literal: true
require "zeitwerk"

module Capistrano
  module Teller
    class Error < StandardError; end
  end
end


loader = Zeitwerk::Loader.for_gem_extension(Capistrano::Teller)
loader.setup # ready!


if defined?(Capistrano::VERSION) && Gem::Version.new(Capistrano::VERSION).release >= Gem::Version.new('3.0.0')
  load File.expand_path("../teller/capistrano/tasks/teller.rake", __FILE__)
end