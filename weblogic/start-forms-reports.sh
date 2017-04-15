# -----------------------------------------------------------------------------------
# File Name    : https://oracle-base.com/dba/weblogic/start-forms-reports.sh
# Author       : Tim Hall
# Description  : Starts a WebLogic Forms and Reports Services installation.
# Call Syntax  : ./start-forms-reports.sh
# Last Modified: 15-JUN-2013
# -----------------------------------------------------------------------------------

export MW_HOME=/u01/app/oracle/middleware
export DOMAIN_HOME=$MW_HOME/user_projects/domains/ClassicDomain
export FR_INST=$MW_HOME/asinst_1

echo "Starting AdminServer"
nohup $DOMAIN_HOME/bin/startWebLogic.sh > /dev/null 2>&1 &
sleep 120

echo "Starting WLS_FORMS"
nohup $DOMAIN_HOME/bin/startManagedWebLogic.sh WLS_FORMS > /dev/null 2>&1 &
echo "Starting WLS_REPORTS"
nohup $DOMAIN_HOME/bin/startManagedWebLogic.sh WLS_REPORTS > /dev/null 2>&1 &

echo "Start remaining processes using OPMN"
$FR_INST/bin/opmnctl startall

echo "Sleep for 10 minutes before calling reports startserver"
sleep 600
curl http://localhost:8888/reports/rwservlet/startserver > /dev/null 2>&1 &

echo "Done!"
