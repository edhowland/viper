# proceed_tab_pt.rb - method proceed_tab_pt - moves buffer to next tab pt

def proceed_tab_pt(buffer)
  result = false
  pos = buffer.position
  buffer.srch_fwd('^.')
  if buffer.at == '^'
    buffer.del_at('^.') 
    result = true
  else
    buffer.goto_position pos
  end

  result
end
