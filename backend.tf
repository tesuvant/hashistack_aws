terraform {
  backend "s3" {
    bucket = "hashistack_aws.tfstate"
    key    = "tf_state"
    region = "eu-north-1"
  }
}
