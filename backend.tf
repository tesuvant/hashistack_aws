terraform {
  backend "s3" {
    bucket = "helloworld.tfstate"
    key    = "tf_state"
    region = "eu-north-1"
  }
}