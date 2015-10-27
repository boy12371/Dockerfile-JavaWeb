#!/bin/bash

cd workspace
svn up --username=jidebingfeng@126.com --password=ccdzfs --no-auth-cache --non-interactive 
rm -rf ${CATALINA_HOME}/webapps
ant