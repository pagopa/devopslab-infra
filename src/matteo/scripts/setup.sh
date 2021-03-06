#!/usr/bin/env bash
set -e

#
# Setup configuration relative to a given subscription
# Subscription are defined in ./subscription
# Usage:
#  ./setup.sh <ENV>
#
#  ./setup.sh dev
#  ./setup.sh uat
#  ./setup.sh prod

SCRIPT_PATH="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
CURRENT_DIRECTORY="$(basename "$SCRIPT_PATH")"
ENV=$1
# must be subscription in lower case
subscription=""

#
# 🏁 start shell init
#
if [ -z "$ENV" ]; then
  echo "[ERROR] ENV should be: dev, uat or prod."
  exit 0
fi

# shellcheck source=/dev/null
source "../../.env/$ENV/backend.ini"

if [ -z "${subscription}" ]; then
    printf "[ERROR] \e[1;31mYou must provide a subscription.\n"
    exit 1
fi

echo "[INFO] This is the current directory: ${CURRENT_DIRECTORY}"

echo "[INFO] Subscription: ${subscription}"
az account set -s "${subscription}"

aks_name="dvopla-d-aksmatteo"
echo "[INFO] aks_name: ${aks_name}"
aks_resource_group_name="dvopla-d-aks-rg"
echo "[INFO] aks_resource_group_name: ${aks_resource_group_name}"

# if using cygwin, we have to transcode the WORKDIR
HOME_DIR=$HOME
if [[ $HOME_DIR == /cygdrive/* ]]; then
  HOME_DIR=$(cygpath -w ~)
  HOME_DIR=${HOME_DIR//\\//}
fi

#
# 🖥 start script
#
rm -rf "${HOME}/.kube/config-${aks_name}"
az aks get-credentials -g "${aks_resource_group_name}" -n "${aks_name}" --subscription "${subscription}" --file "~/.kube/config-${aks_name}"
az aks get-credentials -g "${aks_resource_group_name}" -n "${aks_name}" --subscription "${subscription}" --overwrite-existing

# with AAD auth enabled we need to authenticate the machine on the first setup
echo "Follow Microsoft sign in steps. kubectl get pods command will fail but it's the expected behavior"
kubectl --kubeconfig="${HOME_DIR}/.kube/config-${aks_name}" get pods
kubectl config use-context "${aks_name}"
kubectl get pods
