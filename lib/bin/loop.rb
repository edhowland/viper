# loop - class Loop - command loop - repeats block until break called

class Loop < BaseCommand
  def call *args, env:, frames:
    unless args[0].instance_of? Block
      env[:err].puts "loop: first argument must be a block"
      result = false
    else
      result = true
      block = args[0]
      begin
        loop { result = block.call env:env, frames:frames }
      rescue VirtualMachine::BreakCalled
      # nop
      end

      result
    end
  end
end
