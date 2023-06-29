/*
  ┌───────────────────────────────────────────────────────────────────────┐
  │ generate ssh-keys                                                     │
  └───────────────────────────────────────────────────────────────────────┘
*/

module "ssh_key_pair" {
  source                = "cloudposse/key-pair/aws"
  version               = "0.18.3"
  stage                 = var.environment
  name                  = var.owner
  ssh_public_key_path   = "${path.cwd}/assets/private_keys"
  generate_ssh_key      = "true"
  private_key_extension = ".pem"
  public_key_extension  = ".pub"
}
