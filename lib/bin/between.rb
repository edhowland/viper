# between.rb - class Between - command - outputs first set of lines between
# pattern
# used to capture recorded keystrokes in :_buf/.keylog between fn_6's
# start, end of macro recording session.

class Between < BaseCommand
  def call *args, env:, frames:
    ok = -1
    pattern = args[0]
    env[:in].read.each_line do |line|
      if line.chomp == pattern
        ok += 1
      else
        env[:out].write line if ok.zero?
      end
    end
  end
end
