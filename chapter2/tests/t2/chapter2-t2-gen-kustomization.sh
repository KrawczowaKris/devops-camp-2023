#!/bin/bash

# The script generates ssh-keys for repositories, then starts building
# cli kustomize.

REPOS_PATH="./repos"
KUSTOMIZATION_PATH="${REPOS_PATH}"/kustomization.yaml

# generate_repository_kustomization_config -- takes a repository name
# and generates a repository
#
# usage: generate_repository_kustomization_config <REPOSITORY_NAME>
generate_repository_kustomization_config() {
  local repository_name="${1}"

  ssh-keygen -t ed25519 -N "" -f "${REPOS_PATH}/${repository_name}-deploy-key.pem" -q <<< y > /dev/null 2>&1

  # kustomize repository
  cat << EOF >> "${KUSTOMIZATION_PATH}"
  - name: "${repository_name}"
    namespace: argo-cd
    options:
      labels:
        argocd.argoproj.io/secret-type: repository
    literals:
      - name="${repository_name}"
      - url=git@github.com:KrawczowaKris/${repository_name}.git
      - type=git
      - project=default
    files:
      - sshPrivateKey=${repository_name}-deploy-key.pem
EOF
}

# checking the introduction of arguments
if [ "${#}" -eq 0 ]; then
  echo "No arguments passed. Please add repositories names to proceed."
  exit 1
fi

mkdir -p "${REPOS_PATH}"

# start of file kustomization.yaml
cat << EOF > "${KUSTOMIZATION_PATH}"
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
generatorOptions:
  disableNameSuffixHash: true
secretGenerator:
EOF

for repository_name in ${*}; do
  if [[ ! "${repository_name}" =~ ^[A-Za-z0-9._-]+$ ]]; then
    echo "${repository_name}" is invalid repository name
  else
    generate_repository_kustomization_config "${repository_name}"
  fi
done

kustomize build "${REPOS_PATH}"
