# speachcfg.rb - class  Speachcfg - command speachcfg
# speachcfg allows user to set text to speach engine used by Viper.
# Currently, only stdout and stderr IO classes are supported
# eventually support for GNU espeak engine 
# options
# -o stdout or class name of TTS engine, E.g. EspeakIO
# -e stderr or ...

class Speachcfg < BaseCommand
  def initialize
    @meths = {
      '-o' => :setout,
      '-e' => :seterr,
      'bad juju' => :erra
    }
  end

  attr_reader :meths


  def erra parm, env:
    env[:err].puts 'speachcfg: wrong number of arguments. Requires at least one flag [-o, -e] and argument'
  end

  def errm parm, env:
    env[:err].puts 'speachcfg: Unknown flag'
  end
  def to_meth(chunk)
    @meths[chunk[0]] || :errm
  end

  def setout arg, env:
    env.first[:out] = $stdout
  end

  def seterr arg, env:
    env.first[:err] = $stderr
  end

  def call *args, env:, frames:
    args += ['bad juju', ''] if args.length < 2
    chunkify(args).map {|e| [to_meth(e), e[1]] }.each {|e| self.send *e, env:env }
    true
  end
end

