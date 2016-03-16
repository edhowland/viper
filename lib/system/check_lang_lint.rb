# check_lang_lint.rb - method check_lang_lint - performs passes on buffer

# Exception Lint checker not found for association. Given a Buffer's association, no lint checker could be found for it.
class LintCheckerNotFoundForAssociation < RuntimeError
  def initialize(lang)
    super "No lint checker found for association #{lang}"
  end
end

def check_lang_lint(buffer)
  lang = buffer.association.to_s
  lint_method = "check_#{lang}_lint".to_sym
  begin
    send lint_method, buffer
  rescue NameError => _err
    raise LintCheckerNotFoundForAssociation.new lang
  end
end
