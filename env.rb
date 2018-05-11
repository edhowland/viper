# env.rb - module Env - additional commands in Vish runtime

module Env
  # prints - like puts w/o newline
  def self.prints(string)
    print string
  end
  # error(string) prints string w/padded spaces to stderr
  def self.error(string)
    $stderr.print " #{string} "
    raise string
  end

  # sym(string) - Symbolize any string
  def self.sym(string)
    string.to_sym
  end
  #
  # input read loop
  def self.getchars()
    result = ''
    ch = ' '
    until ch.ord == 27
      ch = $stdin.getch
      print ch
      result << ch unless ch.ord == 27
    end
    result
  end


  # convert string to regex
  def self.regex(string)
    Regexp.new(string)
  end

  # return this many spaces
  def self.spaces(count)
    ' ' * count
  end
  # is a space?
  def self.space?(char)
    char == ' '
  end
  end

  Dispatch << Env
  