# lint.rb - method lint - performs passes on buffer

# TODO: class documentation
class LintCheckerNotFoundForAssociation < RuntimeError
  def initialize(lang)
    super "No lint checker found for association #{lang}"
  end
end

def lint(buffer)
  lang = buffer.association.to_s
  lint_method = "check_#{lang}_lint".to_sym
  begin
    send lint_method, buffer
  rescue => err
    raise LintCheckerNotFoundForAssociation.new lang
  end
end
