# wc - class Wc - command wc - like the bash one
# possible future args:
# -c [default] : prints the character count of the stdin
# -w : prints the word count of the stdin
# -l prints the line count of stdin
# -n  prints w/o newline

class Wc < BaseCommand
  def call *args, env:, frames:
    super do |*a|
      method = :puts
      if@options[:n] 
        method = :print if args[0] == '-n'
      end
      @out.send(method, @in.read.length)
    end
  end
end
