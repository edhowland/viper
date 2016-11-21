# reverse - class Reverse - command reverse - reverses stdin lines

class Reverse < BaseCommand
  def call *args, env:, frames:
    if args.length > 0
      env[:out].puts args.reverse.join(' ')
    else
      input = env[:in].read.each_line.map {|e| e}.reverse.join('')
      env[:out].write input
    end
    true
  end
end
