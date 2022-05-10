resource "random_string" "random" {
  length           = 16
  special          = true
  override_special = "/@£$"
}

resource "random_pet" "weird_pets" {
    count = 7
}