# ipl.rb: initial program load Mainframe-speak for booting

require_relative '../lib/viper'
def ipl
  vm = VirtualMachine.new
  vm.mount('/v', env: vm.ios, frames: vm.fs)
  vm
  end
  
  
  # debug old parser
  def ps(src)
    p = Vish.new(src)
    p.parse && p.result
  end
  
  def p2(src)
    lex src
    lx_run
    p_init
  end
  
  def p3(src)
    vp = VishParser.new(src)
    vp.setup
    vp
  end
  
  # read in file
  def pf(fname)
    p3(File.read(fname))
  end
  
  def le(src)
    l = Lexer.new(src)
    l.run
    l
  end
  
  def lf(fname)
    l=Lexer.new(File.read(fname))
    l.run
    l
  end
  
  # for ease of use in testing parse results from old parser
  def vf(fname)
    Visher.parse!(File.read(fname))
  end
  # parse and read filename for new parser
  def nf(fname)
    p = pf(fname)
    p.p_root
  end