terraform {
  backend "s3" {
    bucket = "hashistack.tfstate"
    key    = "tf_state"
    region = "eu-north-1"
  }
}
