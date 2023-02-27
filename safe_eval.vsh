rem safe_eval.vsh wraps normal eval method checks syntax first
function safe_eval(src) {
   echo :src | vsh_parse blk && exec :blk
}