echo "record.macro: Starts recording keystrokes into /v/macros/0. Usage: record.macro" | desc record.macro
function record.macro() {
echo -n "macro recording started. Press escape when done"
loop {
fn=:(raw -|xfkey | stream_map &(c) { echo -n ":{c} " >> /v/macros/0; echo -n :c })
 eq :fn escape && break
apply :fn 
}
echo -n "Macro recorded. Press F6 to playback"
}
echo "playback.macro: Plays back series of keystrokes from /v/macros/0. Usage: playback.macro" | desc playback.macro
function playback.macro() { 
map &(c) { apply.first :c } :(cat < /v/macros/0)
} 

