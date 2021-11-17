#!/bin/bash

[ ! -f getkc.conf ] && wget http://120.96.143.10/get/getkc.conf -O getkc.conf
source getkc.conf
NAMESPACE=$(ssh  ${UR}@${MAS_IP} "cat ${DIR_ROLE}nslist.txt | grep ${USER} | cut -d ':' -f 1")

if [ "${NAMESPACE}" != "" ]
then
  wget http://120.96.143.10/get/${NAMESPACE}web.zip -O ${NAMESPACE}web.zip &>/dev/null
  [ $? != 0 ] && echo "download ${NAMESPACE}web.zip fail" && exit 1
  unzip ${NAMESPACE}web.zip -d ~/
  [ $? != 0 ] && echo "unzip ${NAMESPACE}web.zip fail" && exit 1
  rm ${NAMESPACE}web.zip  
else
  echo "You are not legal user." && exit 1
fi
