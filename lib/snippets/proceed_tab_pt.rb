# proceed_tab_pt.rb - method proceed_tab_pt - moves buffer to next tab pt


def proceed_tab_pt buffer
  pos = buffer.position
  buffer.srch_fwd('^.')
  if buffer.at == '^'
    buffer.del_at('^.') 
  else
    buffer.goto_position pos
  end
end
