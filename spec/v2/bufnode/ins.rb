# ins - class Ins - command ins - inserts either stdin or arg into line

class Ins < BaseNodeCommand
  def call *args, env:, frames:
    if args.length == 1
      object = env[:in].read
    else
      object = args[1]
    end

    perform(args[0], env:env, frames:frames) do |node|
      left = node['left']
      object.chars.each {|c| left.push c }
      object
    end
  end
end

