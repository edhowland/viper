# wc - class Wc - command wc - like the bash one
# possible future args:
# -c [default] : prints the character count of the stdin
# -w : prints the word count of the stdin
# -l prints the line count of stdin
# -n  prints without printingo newline

class Wc < BaseCommand
  def call *args, env:, frames:
    super do |*a|
      method = :puts
      if@options[:n] 
        method = :print # if args[0] == '-n'
      end
      if @options[:w]
        @output.send(method,@in.read.split(/\b/).map {|e| e.strip }.reject {|e| e.empty? }.length)
      elsif @options[:l]
        @out.puts @in.read.each_line.to_a.length
      else
        @out.send(method, @in.read.length)
      end
    end
  end
end
