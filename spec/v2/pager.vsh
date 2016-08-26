function pager() {
range=1..10
cat < line
for i in :range { apply move_down }
}
bind ctrl_p { pager } { cat }
