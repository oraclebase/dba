# -----------------------------------------------------------------------------------
# File Name    : https://oracle-base.com/dba/weblogic/stop-node-manager.sh
# Author       : Tim Hall
# Description  : Stops the WebLogic Node Manager by killing the processes.
# Call Syntax  : ./stop-node-manager.sh
# Last Modified: 15-JUN-2013
# -----------------------------------------------------------------------------------

echo "Stopping Node Manger"
kill -9 `ps -ef | grep [N]odeManager | awk '{print $2}'`