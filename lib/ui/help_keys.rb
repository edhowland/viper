# help_keys.rb - method help_keys - control loop for help keys command

def help_keys
  say 'Starting keyboard help'
  say 'Type keys to hear their editor actions'
  say 'Hit control q to return to the editor session'
  Viper::Control.loop(help_bindings) do |w|
    key = w.getch
  bind = w.bound_proc_for key
  say bind
  break if key == :ctrl_q
  end

  say 'Stopping keyboard help'
end

