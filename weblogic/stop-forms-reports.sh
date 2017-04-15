# -----------------------------------------------------------------------------------
# File Name    : https://oracle-base.com/dba/weblogic/stop-forms-reports.sh
# Author       : Tim Hall
# Description  : Stop a WebLogic Forms and Reports Services installation.
# Call Syntax  : ./stop-forms-reports.sh
# Last Modified: 15-JUN-2013
# -----------------------------------------------------------------------------------

export MW_HOME=/u01/app/oracle/middleware
export DOMAIN_HOME=$MW_HOME/user_projects/domains/ClassicDomain
export FR_INST=$MW_HOME/asinst_1

echo "Stop OPMN processes"
$FR_INST/bin/opmnctl stopall

echo "Stop WLS_FORMS"
$DOMAIN_HOME/bin/stopManagedWebLogic.sh WLS_FORMS
echo "Stop WLS_REPORTS"
$DOMAIN_HOME/bin/stopManagedWebLogic.sh WLS_REPORTS

echo "Stop AdminServer"
$DOMAIN_HOME/bin/stopWebLogic.sh

echo "Tidy up temp files"
find $DOMAIN_HOME/servers -name "*.lok" -exec rm -f {} \;
find $DOMAIN_HOME/servers -name "*.DAT" -exec rm -f {} \;

echo "Done!"
