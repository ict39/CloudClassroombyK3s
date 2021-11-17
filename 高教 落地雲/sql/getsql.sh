#!/bin/bash

[ ! -f getkc.conf ] && wget http://120.96.143.10/get/getkc.conf -O getkc.conf
source getkc.conf
NAMESPACE=$(ssh  ${UR}@${MAS_IP} "cat ${DIR_ROLE}nslist.txt | grep ${USER} | cut -d ':' -f 1")

if [ "${NAMESPACE}" != "" ]
then
  wget http://120.96.143.10/get/${NAMESPACE}sql.zip -O ${NAMESPACE}sql.zip &>/dev/null
  [ $? != 0 ] && echo "download ${NAMESPACE}sql.zip fail" && exit 1
  unzip ${NAMESPACE}sql.zip -d ~/
  [ $? != 0 ] && echo "unzip ${NAMESPACE}sql.zip fail" && exit 1
  rm ${NAMESPACE}sql.zip  
else
  echo "You are not legal user." && exit 1
fi
