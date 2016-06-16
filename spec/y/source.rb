# source - class Source - command source - reads a .vish file and executes it


class Source
  def call *args, env:
    fail 'Must supply 1 source file' unless args.length == 1
    codes = Visher.parse!(File.read(args[0][0]))
    executor = Executor.new(env)
    executor.execute! codes
  end
end

