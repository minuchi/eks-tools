terraform {
  backend "s3" {
    bucket         = "minuchi-apn2" # your own bucket
    key            = "terrafrom/ap-northeast-2/terraform.tfstate"
    region         = "ap-northeast-2"
    encrypt        = true
    dynamodb_table = "minuchi-terraform-lock" # your own table
  }
}
