# control.rb - module Viper::Control

# Viper root namespace for Viper editor.
module Viper
  # Control main control loop fro Viper editor.
  class Control
    def initialize(proc_bindings = nil)
      @proc_bindings = proc_bindings || make_bindings
    end

    attr_accessor :proc_bindings
    def self.loop(p_bindings = make_bindings, &_blk)
      this = new p_bindings
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
