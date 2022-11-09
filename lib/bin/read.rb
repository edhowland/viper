# read - class Read - command read - stdin is split and stored into vars
# Like the read command in Bash
# No arguments: Eintire stdin is read into the :reply variable
# arguments and matching stdin (which is split with the :ifs variable)
# are matched one by one with arguments
# If more arguments than split stdin, remaining args are made into variables of empty strings
# If less arguments than split stdin, remaining arguments are dumped into the last argument.
# Note: the split stdin are  (via the :ifs var) are rejoined with the :ofs var
# if dumped into either the :reply or the final argument for a fewer than number or total arguments

class Read < BaseCommand
  def call(*args, env:, frames:)
    vars = env[:in].gets.chomp.split(frames[:ifs])
    combine = args.map(&:to_sym).zip vars
    combine.each do |e|
      frames[e[0]] = e[1]
    end
    frames.merge
    true
  end
end
