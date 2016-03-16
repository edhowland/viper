# control.rb - module Viper::Control

# Viper root namespace for Viper editor.
module Viper
  # Control main control loop fro Viper editor.
  class Control
    def initialize(proc_bindings = nil, intra_hooks = [])
      @proc_bindings = proc_bindings || make_bindings
      @intra_hooks = intra_hooks
    end

    attr_accessor :proc_bindings, :intra_hooks

    def self.loop(p_bindings = Viper::Session[:key_bindings], hooks = Viper::Session[:intra_hooks], &_blk)
      this = new(p_bindings, hooks)
      exception_raised = false
      until exception_raised
        begin
          yield this
        rescue => err
          exception_raised = true
          say "Unhandled exception: #{err.class.name}: #{err.message}"
        end
      end
    end

    # Possibly called once within loop block above. Use cases include calling binding.pry
    def intra_hook(that_binding, key, value)
      # put possible hooks here that will be called once per loop
      @intra_hooks.each { |e| e.call(that_binding, key, value) }
    end

    # Gets mapped keystroke as symbol.
    def getch
      map_key(key_press)
    end

    def bound_proc_for(key)
      result = @proc_bindings[key]
      raise BindingNotFound.new "No binding found for #{key}" if result.nil?
      result
    end
  end
end
