rem checkrb syntax checker for Ruby language .rb files
function checkrb() { cat < :_buf | sh - ruby -c }
