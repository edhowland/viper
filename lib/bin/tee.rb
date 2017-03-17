# tee - class Tee - command tee - copies stdout to file and back to stdout

class Tee < BaseCommand
  def call *args, env:, frames:
    super do |*a|
      string = @in.read
      if @options[:a]
        File.open(a[0], 'a') do |f|
          f.write string
        end
      elsif @options[:e]
        env.push
        env[:in] = StringIO.new(string)
        a[0].call env:env, frames:frames
        env.pop
      else
        File.open(a[0], 'w') do |f|
          f.write string
        end
      end
      @out.write string
    end
  end
end
