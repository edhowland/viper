# local.rb - module Viper::Local - user's home path stuff

# Viper root namespace for Viper editor
module Viper
  # Local namespace for user's home path
  module Local
    ROOT = File.expand_path("#{ENV['HOME']}")
  end
end
