# espeak.rb - class  Espeak - command espeak - words to say

require 'espeak'

class Espeak < BaseCommand
  include ESpeak

  def call *args, env:, frames:
    thing = args.join(' ')
    speech = Speech.new(thing)
    speech.speak


    true
  end
end
