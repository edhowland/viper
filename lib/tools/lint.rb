# lint.rb - method lint - performs passes on buffer

def lint buffer
  @blackboard = []
  @blackboard += lint_pass1(buffer)
  @blackboard.unshift 'Lint pass 1 (Even indents) failed'  unless @blackboard.empty?

  # Pass 2 - Check for consistant indenting/outdenting
  # @blackboard.unshift lint_pass2(buffer)
  # @blackboard.unshift 'Lint pass 2 (Consistant indent/outdents) failed' unless @blackboard.empty?

  if @blackboard.empty?
    say 'Lint OK'
  else
    say "lint failed\n"
    @blackboard.each {|log| say "#{log}\n" }
  end
end

