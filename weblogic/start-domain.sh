# -----------------------------------------------------------------------------------
# File Name    : https://oracle-base.com/dba/weblogic/start-domain.sh
# Author       : Tim Hall
# Description  : Starts a WebLogic domain and managed server.
# Call Syntax  : ./start-domain.sh
# Last Modified: 15-JUN-2013
# Notes        : Amend DOMAIN_HOME and managed server name appropriately.
# -----------------------------------------------------------------------------------

export MW_HOME=/u01/app/oracle/middleware
export DOMAIN_HOME=$MW_HOME/user_projects/domains/clusterDomain

echo "Starting AdminServer"
nohup $DOMAIN_HOME/startWebLogic.sh > /dev/null 2>&1 &
sleep 120

echo "Starting clusterServer_1"
nohup $DOMAIN_HOME/bin/startManagedWebLogic.sh clusterServer_1 > /dev/null 2>&1 &
sleep 60

echo "Done!"