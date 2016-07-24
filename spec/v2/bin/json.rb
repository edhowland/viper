# json - class Json - command - outputs hash to stdout, else reads .json to path
# useful for storing things in /v/* to file.json

require 'json'


class StringIO
  def to_json arg=''
    self.string.to_json
  end
end

class Json
  def call *args, env:, frames:
    if args.length == 1
      root = frames[:vroot]
      node = root[args[0]]
      list = node.list
      env[:out].write list.to_json
    end
  end
end

