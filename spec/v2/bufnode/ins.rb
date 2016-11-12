# ins - class Ins - command ins - inserts either stdin or arg into line

class Ins < BaseNodeCommand
  def call *args, env:, frames:
    if args.length == 1
      object = env[:in].read
    else
      object = args[1]
    end
    perform(args[0], env:env, frames:frames) do |node|
      buffer = node['buffer']

      buffer.ins object
       #object.chars.each {|c| buffer.ins c }
      object
    end
  end
end

