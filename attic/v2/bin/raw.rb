# raw - class Raw,  - command raw - reads one char from $stdin into var


require 'remedy'

class Raw < BaseCommand
  include Remedy
  def getch
    Keyboard.get.seq
  end
  def call *args, env:, frames:
    if args[0] == '-'
      env[:out].write getch
    else
      frames[args[0].to_sym] = getch
      frames.merge
    end
    true
  end
end
