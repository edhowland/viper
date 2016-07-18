# instree - class Instree - reads stdin and creates new nodes fro every line


class Instree
  def call *args, env:, frames:
    root = frames[:vroot]
    wd = root.wd
    node = wd
    until env[:in].eof?
      line = env[:in].gets
      node = node.insnode line
    end
    true
  end
end
