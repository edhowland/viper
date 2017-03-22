# loop - class Loop - command loop - repeats block until break called

class Loop < BaseCommand
  def call(*args, env:, frames:)
    if args[0].instance_of? Block
      result = true
      block = args[0]
      begin
        loop { result = block.call env: env, frames: frames }
      rescue VirtualMachine::BreakCalled
        return true
      end

      result
    else
      env[:err].puts 'loop: first argument must be a block'
      result = false
    end
  end
end
