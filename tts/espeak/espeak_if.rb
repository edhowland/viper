# espeak_if.rb - class EspeakIF - interface to GNU espeak engine via espeak-ruby
# For use in Viper: speachcfg -o EspeakIF . Will set this  instead of $stdout
# for all final outputs to standard output. Use -e for standard error : $stderr

class EspeakIF
  include ESpeak

  def say string
    Speech.new(string).speak
  end

  def puts arg
    arg = arg.chomp + "\n"
    say arg
  end

  def print arg
    say arg
  end

  def print arg
    say arg
  end
end
