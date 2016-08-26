function pager(lines) {
range=1..:{lines}
cat < line
for i in :range { apply move_down }
}
page_lines=9
global page_lines
bind ctrl_p { pager :page_lines } { cat }
