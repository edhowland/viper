# eq - class Eq - command eq tests arg1 and arg2 for equality

class Eq  < BaseCommand
  def call *args, env:, frames:
    unless args.length == 2
      arg_error 2, env:env
      false
    else
      args[0] == args[1]
    end
  end
end
