#!/bin/bash

FOLDER_PATH=repos
KUSTOMIZATION_PATH=$FOLDER_PATH/kustomization.yaml

# generate_repository -- takes a repository name and generates a repository
#
# usage: generate_repository <NAME_REPOSITORY>

generate_repository_kustomization_config() {
  local repository_name="$1"

  ssh-keygen -y -t ed25519 -N "" -f $FOLDER_PATH/"$repository_name"-deploy-key.pem -q

# kustomize repository
  cat << EOF >> "$FOLDER_PATH"/kustomization.yaml
  - name: "$repository_name"
    namespace: argo-cd
    options:
      labels:
        argocd.argoproj.io/secret-type: repository
    literals:
      - name="$repository_name"
      - url=git@github.com:KrawczowaKris/"$repository_name".git
      - type=git
      - project=default
    files:
      - sshPrivateKey=$repository_name-deploy-key.pem
EOF
}

# checking the introduction of arguments
if [ "$#" -eq 0 ]; then
  echo "No arguments passed. Please add repositories names to proceed."
  exit 1
fi

# start of file kustomization.yaml
cat << EOF > $KUSTOMIZATION_PATH
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
generatorOptions:
  disableNameSuffixHash: true
secretGenerator:
EOF

for repository_name in $*; do
  generate_repository_kustomization_config "$repository_name"
done

# kustomize build repositories
kustomize build repos
