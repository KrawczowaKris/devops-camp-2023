/*
  ┌───────────────────────────────────────────────────────────────────────┐
  │ generate password for rds                                             │е7ЕН
  └───────────────────────────────────────────────────────────────────────┘
*/

resource "random_password" "rds_admin_password" {
  length  = 16
  special = false
}

/*
  ┌───────────────────────────────────────────────────────────────────────┐
  │ generate authentication unique keys and salts for wp-config.php       │
  └───────────────────────────────────────────────────────────────────────┘
*/

resource "random_string" "random" {
  for_each         = toset(var.wordpress_labels_random_values)
  length           = 64
  special          = true
  override_special = "<>{}()+*=#@;_/|"
}
