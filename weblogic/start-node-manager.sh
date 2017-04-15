# -----------------------------------------------------------------------------------
# File Name    : https://oracle-base.com/dba/weblogic/start-node-manager.sh
# Author       : Tim Hall
# Description  : Starts the WebLogic Node Manager
# Call Syntax  : ./start-node-manager.sh
# Last Modified: 15-JUN-2013
# -----------------------------------------------------------------------------------

export MW_HOME=/u01/app/oracle/middleware
export WLS_HOME=$MW_HOME/wlserver_10.3

echo "Starting Node Manger"
nohup $WLS_HOME/server/bin/startNodeManager.sh > /dev/null 2>&1 &

echo "Done!"
