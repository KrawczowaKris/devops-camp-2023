#
# generate_repository -- takes a repository name and generates a repository
#
# usage: generate_repository <NAME_REPOSITORY>
#
generate_repository() { 
	local name_repository=$1

# kustomize repository
cat << EOF >> ~/github_repos/devops-camp-2023/kustomization.yaml
  - name: $name_repository
    namespace: argo-cd
    options:
      labels:
        argocd.argoproj.io/secret-type: repository
    literals:
      - name=$name_repository
      - url=git@github.com:KrawczowaKris/$name_repository.git
      - type=git
      - project=default
    files:
      - sshPrivateKey=./ssh-keys/$name_repository-deploy-key.pem
EOF
}

# checking the introduction of arguments
if [ $# -eq 0 ]
	then echo "Please enter arguments"
	exit 1
fi

# start of file kustomization.yaml
cat << EOF > ~/github_repos/devops-camp-2023/kustomization.yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

generatorOptions:
  disableNameSuffixHash: true

secretGenerator:
EOF

names_repositories=$*

for name_repository in $names_repositories; do
	# generate ssh keys
	ssh-keygen -t ed25519 -N "" -f ~/github_repos/devops-camp-2023/ssh-keys/$name_repository-deploy-key.pem

	generate_repository $name_repository
done

# kustomize build repositories
kustomize build ~/github_repos/devops-camp-2023 > ~/github_repos/devops-camp-2023/output.yaml
