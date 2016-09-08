echo "record.macro.file: Record macro to specific file in VFS, creating it first. Usage: record.macro.file /v/macros/macro_name" | desc record.macro.file
function record.macro.file(fname) {
echo -n "macro recording started. Press escape when done"
touch :fname
loop {
fn=:(raw -|xfkey | stream_map &(c) { echo -n ":{c} " >> :fname; echo -n :c })
 eq :fn escape && break
apply :fn 
}
}
echo "record.macro: Starts recording keystrokes into /v/macros/0. Usage: record.macro" | desc record.macro
function record.macro() {
record.macro.file /v/macros/0
echo -n "Macro recorded. Press F6 to playback"
}
echo "playback.macro.file: Plays back macro stored in file in current buffer. Usage: playback.macro.file file ... where is file is /v/macros/file" | desc playback.macro.file
function playback.macro.file(fname) { 
map &(c) { apply.first :c } :(cat < :fname)
} 
echo "playback.macro: Plays back series of keystrokes from /v/macros/0. Usage: playback.macro" | desc playback.macro
function playback.macro() {
playback.macro.file /v/macros/0
echo -n Macro inserted
}
function record.snip(name) {
assc=:(assoc)
record.macro.file /v/snips/:{assc}/:{name}
}
function playback.snip(name) {
assc=:(assoc)
playback.macro.file /v/snips/:{assc}/:{name}
goto.tabpt
}

