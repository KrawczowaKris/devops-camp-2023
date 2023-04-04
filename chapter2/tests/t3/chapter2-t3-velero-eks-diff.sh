#!/bin/bash

# The bash script looks for all namespaces in the cluster that have not been configured
# in the velero manifest. those. operations on sets.

configuration_backups=$(curl -sSL \
  https://gist.github.com/dmitry-mightydevops/016139747b6cefdc94160607f95ede74/raw/velero.yaml)
namespaces=$(curl -sSL \
  https://gist.github.com/dmitry-mightydevops/297c4e235b61982f21a0bbbf7319ac24/raw/kubernetes-namespaces.txt)

echo "${configuration_backups}" | yq ".spec.source.helm.values" \
  | yq ".schedules[].template.includedNamespaces[]" | sort > configured_ns.txt

while read conf_ns; do
  namespaces="${namespaces[@]/$conf_ns}"
done < configured_ns.txt

for namespace in $namespaces; do
  echo "${namespace}"
done

