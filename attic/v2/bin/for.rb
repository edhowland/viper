# for - class For - control loop: for - for i in ... { block }
# var:i or named param is created as variable inside block

class For < BaseCommand
  def call *args, env:, frames:
    var, in_p = args.shift(2)
    raise Vish::SyntaxError if in_p.nil? || in_p != 'in' || args.empty?
    block = args.pop
    var = var.to_sym
    begin
      args.each do |e|
        frames[var] = e
        block.call env:env, frames:frames
      end
    rescue VirtualMachine::BreakCalled
      # nop
    ensure
      frames.merge
    end
    true
  end
end

