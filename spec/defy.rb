#!/usr/bin/env ruby
# defy.rb - .setup a small curses app

require 'curses'
require_relative '../lib/viper'

def attempt &blk
  Curses.init_screen
  begin
    yield
  ensure
    Curses.close_screen
  end
end
