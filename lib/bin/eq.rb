# eq - class Eq - command eq tests arg1 and arg2 for equality

class Eq < BaseCommand
  def call(*args, env:, frames:)
    if args.length == 2
      args[0] == args[1]
    else
      arg_error 2, env: env
      false
    end
  end
end
