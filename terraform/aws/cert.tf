resource "tls_private_key" "boundary" {
  algorithm = "RSA"
}

resource "tls_self_signed_cert" "boundary" {
  key_algorithm   = "RSA"
  private_key_pem = tls_private_key.boundary.private_key_pem

  subject {
    common_name  = "boundary.dev"
    organization = "Boundary, dev."
  }

  validity_period_hours = 12

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
}

# Create TLS infra for Vault
# resource "tls_private_key" "vault_ca" {
#   algorithm = "RSA"
#   rsa_bits = 4096
# }

# resource "tls_self_signed_cert" "vault_ca" {
#   key_algorithm = tls_private_key.vault_ca.algorithm
#   subject {
#     common_name  = "vault.dev"
#     organization = "Vault, dev."
#   }
#   validity_period_hours = 12
#   allowed_uses = [
#     "key_encipherment",
#     "digital_signature",
#     "server_auth",
#   ]
# }
