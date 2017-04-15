# -----------------------------------------------------------------------------------
# File Name    : https://oracle-base.com/dba/weblogic/stop-domain.sh
# Author       : Tim Hall
# Description  : Stops a WebLogic domain and managed server.
# Call Syntax  : ./stop-domain.sh
# Last Modified: 15-JUN-2013
# Notes        : Amend DOMAIN_HOME and managed server name appropriately.
# -----------------------------------------------------------------------------------

export MW_HOME=/u01/app/oracle/middleware
export DOMAIN_HOME=$MW_HOME/user_projects/domains/clusterDomain

echo "Stopping clusterServer_1"
$DOMAIN_HOME/bin/stopManagedWebLogic.sh clusterServer_1

echo "Stopping AdminServer"
$DOMAIN_HOME/bin/stopWebLogic.sh

echo "Tidy up temp files"
find $DOMAIN_HOME/servers -name "*.lok" -exec rm -f {} \;
find $DOMAIN_HOME/servers -name "*.DAT" -exec rm -f {} \;

echo "Done!"