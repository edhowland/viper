function setup(l, r) { open file.txt; mklx :l :r }
function mr() { deq lx/right | push lx/left; peek lx/right; echo }
function ml() { pop lx/left | enq lx/right; peek lx/right; echo }
