# lint.rb - method lint - performs passes on buffer

def lint buffer
  @blackboard = []
  @blackboard += lint_pass1(buffer)
  @blackboard.unshift 'Lint pass 1 (Even indents) failed'  unless @blackboard.empty?

  # Pass 2 - Check for consistant indenting/outdenting
  pass2 = lint_pass2(buffer)
  unless pass2.empty?
    pass2.unshift "Pass 2 failed: Inconsisant indentation: Indents vs. Outdents"
    @blackboard += pass2
  end

  if @blackboard.empty?
    say 'Lint OK'
  else
    suppress_audio { exec_cmd :new, buffer} 
    say "lint failed\n"
    lint_buffer = $buffer_ring.first
    lint_buffer.ins @blackboard.join("\n")
    lint_buffer.beg
    lint_buffer.name = 'Lint results'
    say lint_buffer.line
  end
end

