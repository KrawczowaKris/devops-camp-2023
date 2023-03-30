#!/bin/bash

# generate_repository -- takes a repository name and generates a repository
#
# usage: generate_repository <NAME_REPOSITORY>

FOLDER_PATH="/home/nadya/github_repos/devops-camp-2023"

generate_repository_kustomization_config() {
  local repository_name=$1

  ssh-keygen -t ed25519 -N "" -f /repos/ssh-keys/$repository_name-deploy-key.pem

# kustomize repository
cat << EOF >> /repos/kustomization.yaml
  - name: $repository_name
    namespace: argo-cd
    options:
      labels:
        argocd.argoproj.io/secret-type: repository
    literals:
      - name=$repository_name
      - url=git@github.com:KrawczowaKris/$repository_name.git
      - type=git
      - project=default
    files:
      - sshPrivateKey=/repos/ssh-keys/$repository_name-deploy-key.pem
EOF
}

# checking the introduction of arguments
if [ $# -eq 0 ]; then
  echo "No arguments passed. Please add repositories names to proceed."
  exit 1
fi

# start of file kustomization.yaml
cat << EOF > /repos/kustomization.yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

generatorOptions:
  disableNameSuffixHash: true

secretGenerator:
EOF

REPOSITORY_NAMES=$*

for repository_name in $REPOSITORY_NAMES; do
  generate_repository_kustomization_config $repository_name
done

# kustomize build repositories
kustomize build $FOLDER_PATH > /repos/output.yaml
