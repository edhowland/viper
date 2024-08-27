# one_test will only run a single test_ file
source vunit.vsh
tf=:(second :argv)
echo "About to run:{tf}" 
source :tf
