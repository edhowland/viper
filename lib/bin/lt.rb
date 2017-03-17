# lt.rb - class Lt - command lt - returns true if args are less than

class Lt < BaseCommand
  def call(*args, env:, frames:)
    if args.length == 2
      args[0].to_i < args[1].to_i
    else
      arg_error 2, env: env
      false
    end
  end
end
