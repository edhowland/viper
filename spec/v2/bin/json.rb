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
    root = frames[:vroot]

    if args.length == 1
      node = root[args[0]]
      list = node.list
      env[:out].write list.to_json
    else
      # assume 2 args: TODO: add error check
      storage = JSON.load(File.read(args[0]))
      #storage = storage.to_a.map {|kv| kv[1] = StringIO.new(kv[1]) }.to_h
      storage = storage.to_a
      storage = storage.map {|kv| [kv[0], StringIO.new(kv[1])] }.to_h
#      binding.pry
      
      node = root[args[1]]
      node.list = storage
    end
    true
  end
end

