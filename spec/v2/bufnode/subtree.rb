# subtree - class Subtree - command subtree - grabs eepth sub nodes
# and sends to stdout


class Subtree
  def call *args, env:, frames:
    if args.empty?
      env[:err].puts 'subtree: must supply depth argument'
      false
    else
      depth = args[0].to_i
      root = frames[:vroot]
      node = root.wd
      env[:out].puts node['line'].string
      # recurse down max depth
      true
    end
  end
end
