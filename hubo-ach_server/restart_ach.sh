#!/bin/bash
sudo /usr/bin/hubo-ach killall
# Note: If you do not redirect the output of hubo-ach remote to /dev/null, a successful
# connection will result in a persistant pipe, causing Node's exec() to never call it's 
# callback function. (Alternatively, use the "timeout" option in exec().) Note that this
# is NOT the case for an unsuccessful attempt to connect, which result in the achd 
# processes killing themselves and thus ending the output.
sudo /usr/bin/hubo-ach remote hubo 1>/dev/null 2>&1
#sudo /usr/bin/hubo-ach virtual &
