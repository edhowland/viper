# env.rb - module Env - additional commands in Vish runtime

module Env
  def self.getargs()
    ARGV
  end
  end
  
  Dispatch << Env
  