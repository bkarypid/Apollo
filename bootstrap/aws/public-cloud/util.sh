#!/bin/bash

# Use the config file specified in $APOLLO_CONFIG_FILE, or default to
# config-default.sh.

APOLLO_TF_ROOT="${APOLLO_TF_ROOT:-$( ${APOLLO_ROOT}/terraform/${APOLLO_PROVIDER})}"

ansible_ssh_config() {
  pushd "${APOLLO_TF_ROOT}"
    cat <<EOF > ssh.config
  Host *
    StrictHostKeyChecking  no
    ServerAliveInterval    120
    ControlMaster          auto
    ControlPath            ~/.ssh/mux-%r@%h:%p
    ControlPersist         30m
    User                   core
    UserKnownHostsFile     /dev/null
EOF
  popd
}

apollo_down() {
  pushd "${APOLLO_TF_ROOT}"
    terraform destroy -var "access_key=${TF_VAR_access_key}" \
      -var "key_file=${TF_VAR_key_file}" \
      -var "region=${TF_VAR_region}"
  popd
}

