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