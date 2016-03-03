# check_lang_syntax.rb - method check_lang_syntax check syntax of buffer's association
def check_lang_syntax buffer
  lang = buffer.association
  syntax_checker = "check_#{lang}_syntax"
  begin
    send syntax_checker.to_sym, buffer
  rescue => err
    say"No syntax check method for buffer #{buffer.name} with association #{buffer.association}"
  end
end

