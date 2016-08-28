# grep - class Grep - command grep - looks for regex in lines
# args -o : only output matched chars

class Grep < BaseCommand
  def call *args, env:, frames:
    super do |*a|
      pattern = a.shift
      regex = %r{#{pattern}}
      result = false
      @in.read.each_line do |l|
        if l =~ regex
        result = true
        pout l.chomp
      end
      end
      result
    end
  end
end
