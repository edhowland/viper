function meta(fn) {
for i in 1 2 {
capture {
:fn
} {
fn=:last_exception; global fn
} 
}
}

