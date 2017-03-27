# between.rb - class Between - command between  guard - outputs lines between
# guard lines
# Eg.: cat < :_buf | between xxx  # prints lines between  xxx lines, exclusive

class Btw < BaseCommand
  def call(*args, env:, frames:)
    pattern = args.first
    lines = env[:in].read.lines
    ms = lines.map {|e| e.chomp == pattern }
    nums = ms.each_with_index.to_a
env[:err].puts  ms.inspect
    nums.select! {|e| e[0] }
env[:err].puts nums.inspect
    nums.map! {|e| e[1] }
    start, fin = nums
    env[:err].puts "start: #{start}, fin: #{fin}"

    start += 1
    fin -= 1
    env[:err].puts "start: #{start}, fin: #{fin}"
    env[:out].print lines[start..fin].join('')
    true
  end
end
