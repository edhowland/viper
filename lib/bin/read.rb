# read - class Read - command read - stdin is split and stored into vars
# Like the read command in Bash
# No arguments: Eintire stdin is read into the :reply variable
# arguments and matching stdin (which is split with the :ifs variable)
# are matched one by one with arguments
# If more arguments than split stdin, remaining args are made into variables of empty strings
# If less arguments than split stdin, remaining arguments are dumped into the last argument.
# Note: the split stdin are  (via the :ifs var) are rejoined with the :ofs var
# if dumped into either the :reply or the final argument for a fewer than number or total arguments

class Read < BaseCommand
  def call(*args, env:, frames:)
    if args.length.zero?
      frames[:reply] = env[:in].read.chomp.split(frames[:ifs]).join(frames[:ofs])
      frames.merge
      return true
    else
      list = env[:in].read.chomp.split(frames[:ifs])
#$stderr.puts "list: #{list}, args #{args}, lt eq gt: #{list.length <=> args.length}"
      # echo list | read [args]. Maintain this order
      case list.length <=> args.length
      when -1   # list.length < args.length
        args.map(&:to_sym).zip(list).map {|e| e[1].nil? ? [e[0], ''] : e }.each {|k, v| frames[k] = v }
      when 0
        args.map(&:to_sym).zip(list).each {|k,v| frames[k] = v }
      when 1
        kargs = args.map(&:to_sym)
        smargs = kargs[..-2]
        smargs.zip(list[..(smargs.length)]).each {|k,v| frames[k] = v }
        frames[kargs[-1]] = list[(kargs.length - 1)..].join(frames[:ofs])
      end
        frames.merge
      return true
    end

  end
end
