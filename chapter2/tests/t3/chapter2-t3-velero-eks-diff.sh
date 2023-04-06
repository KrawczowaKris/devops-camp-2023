#!/bin/bash

# The bash script looks for all namespaces in the cluster that have not been configured
# in the velero manifest. those. operations on sets.

# check_file_existence -- checks for the existence of a file and that it is not empty
#
# usage: check_file_existence <FILE_NAME> <FILE_CONTENTS>
#
check_file_existence() {
  local filename="$1"
  local file=$(echo "$2" | sed 's/\n//')

  if [[ "${file}" = "404: Not Found" ]]; then
    echo File "${filename}" does not exist at the this link.
    exit 1
  fi

  if [[ -s "${file}" ]]; then
    echo File "${filename}" is empty.
    exit 1
  fi
}

backup_namespaces=$(curl -sSL \
  https://gist.github.com/dmitry-mightydevops/016139747b6cefdc94160607f95ede74/raw/velero.yaml)
check_file_existence "velero.yaml" "${backup_namespaces}"

kubernetus_namespaces=$(curl -sSL \
  https://gist.github.com/dmitry-mightydevops/297c4e235b61982f21a0bbbf7319ac24/raw/kubernetes-namespaces.txt)
check_file_existence "kubernetes-namespaces.txt" "${kubernetes_namespaces}"

# Retrieve the list of namespaces, sort them and store them in an array
configured_ns=( $(echo "$backup_namespaces" | yq ".spec.source.helm.values" \
  | yq ".schedules[].template.includedNamespaces[]" | sort ) )

for conf_ns in "${configured_ns[@]}"; do
  kubernetus_namespaces="${kubernetus_namespaces[@]/$conf_ns}"
done;

echo $kubernetus_namespaces | tr " " "\n"
