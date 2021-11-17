#!/bin/bash
[ -f ~/.kube/config ] && echo "k3s config exist" && exit 0
wget http://120.96.143.10/get/getkc.conf -O getkc.conf &>/dev/null
[ $? != 0 ] && echo "download getkc.conf fail" && exit 1

source getkc.conf
echo '' | ssh-keygen -t rsa -P '' &>/dev/null
sshpass -p mysre ssh-copy-id ${UR}@${MAS_IP} &>/dev/null
mkdir -p /home/${USER}/.kube &>/dev/null

ssh ${UR}@${MAS_IP} "ls -al ${DIR_CSR}${USER}.conf" &>/dev/null
if [ $? = 0 ]; then
  scp ${UR}@${MAS_IP}:${DIR_CSR}${USER}.conf ~/.kube/config &>/dev/null
else
  NAMESPACE=$(ssh  ${UR}@${MAS_IP} "cat ${DIR_ROLE}nslist.txt | grep ${USER} | cut -d ':' -f 1")
  if [ $NAMESPACE != '' ]; then
    ssh ${UR}@${MAS_IP} "${DIR_ROLE}mkubeuser.sh ${NAMESPACE} ${USER}" &>/dev/null && echo "K3SUSER:${USER} created"
    ssh ${UR}@${MAS_IP} "${DIR_ROLE}mkcontext.sh ${NAMESPACE} ${USER}" &>/dev/null && echo "K3SCONTEXT:${USER} created"
    scp ${UR}@${MAS_IP}:${DIR_CSR}${USER}.conf ~/.kube/config &>/dev/null && echo "K3SCONFIG created"
  else
    echo "you are not in the list" && exit 1
  fi
fi

which kubectl &>/dev/null
[ $? = 0 ] && echo "you had already have kubectl" && exit 0 
curl -LO https://dl.k8s.io/release/v1.21.0/bin/linux/amd64/kubectl && chmod +x kubectl && sudo mv kubectl /usr/bin
[ $? != 0 ] && echo "download kubectl fail" && exit 1

