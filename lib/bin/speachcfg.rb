# speachcfg.rb - class  Speachcfg - command speachcfg
# speachcfg allows user to set text to speach engine used by Viper.
# Currently, only stdout and stderr IO classes are supported
# eventually support for GNU espeak engine 
# options
# -o stdout or class name of TTS engine, E.g. EspeakIO
# -e stderr or ...

class Speachcfg < BaseCommand
  def initialize
    lambs = {
      '-o': nil,
      '-e': nil
    }
  end
  def setout arg, env:
    env.first[:out] = $stdout
  end
  
  def seterr arg, env:
    env.first[:err] = $stderr
  end

  def call *args, env:, frames:
    if args.length < 2
      env[:err].puts 'speachcfg: requires at least one flag and argument'
      return false
    end
    opt, parm = args
    setout(parm, env:env) if opt == '-o'
    seterr(parm, env:env) if opt == '-e'
    true
  end
end

