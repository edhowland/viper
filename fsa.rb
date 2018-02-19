# fsa.rb - Finite State Automata

require 'micromachine'


def fsa
  m = MicroMachine.new :idle
  # define transitions
  m.when :key_press, { idle: :pressed }
  m.when :exit, { pressed: :exit,
      idle: :exit }
  m.when(:reset, { idle: :idle,
  pressed: :idle,
  exit: :idle })

  # add callbacks
  m.on(:idle) { puts 'in idle' }
  m.on(:pressed) { puts "a key was pressed" }
  m.on(:exit) { puts 'getting out of dodge' }

  m
end

def get_state(ch)
  if ch == 'q'
    :exit
  elsif ch == 'r'
    :reset
  else
    :key_press
  end
end

def events
  m = fsa
  puts 'Type a key. q to quit or r to reset'
  until m.state == :exit
    m.trigger :reset
    event = get_state($stdin.getch)
    m.trigger event
  end
end