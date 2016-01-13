# shell.rb - method shell runs a command returning stdout, stderr

# run command piping value from block to stdin, return stdout, stderr
def shell command, &blk
  output, error = ''
  begin
  stdin, stdout, stderr = Open3.popen3(command)
  yield stdin
  stdin.close
  output = stdout.read
  error = stderr.read
  ensure
    stdout.close
    stderr.close
  end

  [output, error]
end
