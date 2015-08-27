#!/bin/bash
set -e

VENV=${INFRA_ANSIBLE_VENV:-"venv"}
ANSIBLE_VERSION="e8452c864e57d39c703ff1317a70981600c23310"

virtualenv ${VENV}
curl -O https://bootstrap.pypa.io/get-pip.py
${VENV}/bin/python get-pip.py
${VENV}/bin/pip install -r "$(dirname $0)/requirements.txt"
${VENV}/bin/pip install git+https://github.com/ansible/ansible.git@${ANSIBLE_VERSION}
# XXX: Only way to get the openstack.py inventory plugin
rm -rf ansible
git clone https://github.com/ansible/ansible.git
pushd ansible
git reset --hard ${ANSIBLE_VERSION}
popd

echo ========================================================================
echo If you have elected to provide cloud provider details via environment
echo variables, source that file.  Otherwise, we assume you are managing that
echo information with os-client-config and in that case, replace 'envvars' in
echo your infra_config.yaml file with the name of a cloud provider you have
echo ========================================================================
