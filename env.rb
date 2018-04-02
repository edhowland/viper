# env.rb - module Env - additional commands in Vish runtime

module Env
  # prints - like puts w/o newline
  def self.prints(string)
    print string
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

  # list stuff from scheme
  def self.car(pair)
    pair.key
  end
  def self.cdr(pair)
    pair.value
  end
  def self.cons(ar, dr)
    PairType.new(key: ar, value: dr)
  end

  # convert string to regex
  def self.regex(string)
    Regexp.new(string)
  end
  end

  Dispatch << Env
  