terraform {
  required_version = ">= 0.12"
}

locals {
  region-to-az-count-map = {
    "us-west-1" = 3
    "us-west-2" = 3
    "us-east-1" = 6
    "us-east-2" = 3
  }

  num-to-az-letter-map = {
    "0" = "a"
    "1" = "b"
    "2" = "c"
    "3" = "d"
    "4" = "e"
    "5" = "f"
  }
}
