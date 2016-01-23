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

  # Pass3 Excessive blank lineage
  pass3 = lint_pass3(buffer)
  unless pass3.empty?
    pass3.unshift "Pass 3 failed: Excessive blank lineage"
    @blackboard += pass3
  end

  if @blackboard.empty?
    say 'Lint OK'
  else
    suppress_audio { exec_cmd :new, buffer} 
    say "lint failed\n"
    lint_buffer = $buffer_ring.first
    lint_buffer.ins @blackboard.join("\n")
    lint_buffer.beg
    lint_buffer.name = "Lint results for #{buffer.name}"
    say lint_buffer.line
  end
end

