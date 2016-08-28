# grep - class Grep - command grep - looks for regex in lines
# args -o : only output matched chars

class Grep < BaseCommand
  def regexp string
    if string[0] == '/'
      Regexp.new string[1..-2]
    else
      Regexp.new string
    end
  end
  
  def say string
    if @options[:n]
      @out.print string
    else
      @out.puts string
    end
  end

  def call *args, env:, frames:
    super do |*a|
      pattern = a.shift
      regex = regexp pattern
      result = false
      @in.read.each_line do |l|
        matches = l.match regex
        if matches
        result = true
        if @options[:o]
          say matches[1]
        else
          say matches[0]
        end
      end
      end
      result
    end
  end
end
