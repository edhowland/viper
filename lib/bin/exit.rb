# exit.rb - class Exit- exits out the repl

class Exit < BaseCommand
  def call *args, env:, frames:
    raise VirtualMachine::ExitCalled
  end
end

