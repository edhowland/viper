# grep - class Grep - command grep - looks for regex in lines


class Grep
  def call *args, env:, frames:
    pattern = args.shift
    regex = %r{#{pattern}}
    result = false
    env[:in].read.each_line do |l|
      if l =~ regex
        result = true
        env[:out].puts l.chomp
      end
    end
    result
  end
end
