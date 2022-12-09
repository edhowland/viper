rem tasks to performafter these scripts have been loaded
rem we have been placed in another present working directory
__FILE__=init
cd :latest_wd
for s in :(getvalopt -s) { source :s }
suppress { cd - }
echo vish has started

