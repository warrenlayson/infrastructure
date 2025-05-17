resource "vault_policy" "pki" {
  name = "pki"

  policy = <<EOT
path "pki*"                             { capabilities = ["read", "list"] }
path "pki_int/sign/warrenlayson-dot-xyz"    { capabilities = ["create", "update"] }
path "pki_int/issue/warrenlayson-dot-xyz"   { capabilities = ["create"] }
    EOT
}
