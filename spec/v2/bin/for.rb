# for - class For - control loop: for - for i in ... { block }
# var:i or named param is created as variable inside block

class For
  def call *args, env:, frames:
    var, in_p = args.shift(2)
    raise Vish::SyntaxError if in_p.nil? || in_p != 'in' || args.empty?
    block = args.pop
    vm = frames.vm
    var = var.to_sym
    args.each {|e| vm.fs[var] = e; vm.call block }
    true
  end
end

