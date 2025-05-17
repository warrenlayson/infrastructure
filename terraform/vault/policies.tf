resource "vault_policy" "pki" {
  name = "pki"

  policy = <<EOT
path "pki*"                             { capabilities = ["read", "list"] }
path "pki/sign/warrenlayson-dot-xyz"    { capabilities = ["create", "update"] }
path "pki/issue/warrenlayson-dot-xyz"   { capabilities = ["create"] }
    EOT
}
