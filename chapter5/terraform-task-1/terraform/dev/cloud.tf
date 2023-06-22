terraform {
  cloud {
    organization = "saritasa-devops-camps"

    workspaces {
      tags = [
        "owner:nadezhda-niukina-user",
        "lecture:environments",
        "env:dev"
      ]
    }
  }
}
