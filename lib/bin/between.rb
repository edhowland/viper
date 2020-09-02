# between.rb - class Between - command between  guard - outputs lines between
# guard lines
# Eg.: cat < :_buf | between xxx  # prints lines between  xxx lines, exclusive
# rubocop:disable Metrics/AbcSize

class Between < BaseCommand
  def call(*args, env:, frames:)
    pattern = args.first
    lines = env[:in].read.lines
    ms = lines.map { |e| e.chomp == pattern }
    nums = ms.each_with_index.to_a
    nums.select! { |e| e[0] }
    nums.map! { |e| e[1] }
    start, fin = nums
    start = -1 if start.nil?
    start += 1
    fin = 0 if fin.nil?
    fin -= 1
    env[:out].print lines[start..fin].join('')
    true
  end
end
