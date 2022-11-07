# test_ helper.rb: requires for testing
require_relative '../lib/viper'
# Put test helper classes and modules here
require_relative 'lib/ext_assertions'
require_relative 'lib/my_mock'

# helper function to get boot.vsh path

def boot_vsh
  File.expand_path("#{__dir__}/../pry/boot.vsh")
end

# add nothing further than the next line
require 'minitest/autorun'

