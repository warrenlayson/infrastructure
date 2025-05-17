data "terraform_remote_state" "keypairs" {
  backend = "local"
  config = {
    path = "../../keypairs/terraform.tfstate"
  }
}
