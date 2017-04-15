#!/bin/bash
path=$1
app=$2
targetlist=$3

export MW_HOME=/u01/app/oracle/middleware
export DOMAIN_HOME=$MW_HOME/user_projects/domains/myDomain
. $DOMAIN_HOME/bin/setDomainEnv.sh

if [ "$app" != "" -a "$targetlist" = "" ]; then
  java weblogic.WLST ~/scripts/deploy_app.py -p $path -a $app
elif [ "$app" != "" -a "$targetlist" != "" ] ; then
  java weblogic.WLST ~/scripts/deploy_app.py -p $path -a $app -t $targetlist
else
  java weblogic.WLST ~/scripts/deploy_app.py -p $path
fi
