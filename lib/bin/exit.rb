# exit.rb - class Exit- exits out the repl

class Exit < BaseCommand
  def call(*args, env:, frames:)
    code = 0
    code = args[0].to_i unless args.empty?
    frames.first[:exit_code] = code
    raise VirtualMachine::ExitCalled, code
  end
end
