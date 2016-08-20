# echo - class Echo

class Echo < BaseCommand
  def spit args
    args.join(' ')
  end
  def call *args, env:, frames:
    super do |*a|
      if @options[:n]
        @out.write spit(a)
      else
        pout spit(a)
      end
    end
  end
  
end
