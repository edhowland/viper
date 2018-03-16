# env.rb - module Env - additional commands in Vish runtime

module Env
  def self.getargs()
    ARGV
  end

  # prints - like puts w/o newline
  def self.prints(string)
    print string
  end

  # sym(string) - Symbolize any string
  def self.sym(string)
    string.to_sym
  end
  end

  Dispatch << Env
  