# vish - class Vsh - command vsh "string of commands" - runs Vish parser,vm on
# string
# args:
# -e true|false - sets initial value of :exit_status

class Vsh < BaseValueCommand
  def normalize_status(status)
    status = (status.nil? ? true : status)
    status = (status.empty? ? true : status)
    status
  end

  def call(*args, env:, frames:)
    super do |*a|
      code = a.join(' ').chomp
      return true if code.empty?
      block = Visher.parse! code

      vm = frames.vm
      frames.first[:exit_status] = @options[:e] unless @options[:e].nil?
      # binding.pry
      result = vm.call block
      # globalize any variables gathered via above execution
      vm.fs.top.each_pair {|k,v| vm.fs.first[k] = v }
#      frames.keys.each { |k| frames.first[k] = frames[k] }

      result
    end
  end
end
