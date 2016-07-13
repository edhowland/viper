# exit.rb - class Exit- exits out the repl

class Exit
  def call *args, env:, frames:
    exit
  end
end

