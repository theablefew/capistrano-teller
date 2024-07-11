# frozen_string_literal: true

require "zeitwerk"
loader = Zeitwerk::Loader.for_gem_extension(Capistrano::Teller)
loader.setup # ready!

module Capistrano
  module Teller
    class Error < StandardError; end


  end
end


if defined?(Capistrano::VERSION) && Gem::Version.new(Capistrano::VERSION).release >= Gem::Version.new('3.0.0')
  load File.expand_path("../teller/capistrano/tasks/teller.rake", __FILE__)
end