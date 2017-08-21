#!/usr/bin/env ruby
# try out espeak-ruby

 require 'espeak'

include ESpeak
speech = Speech.new("YO!")
speech.speak # invokes espeak
