# https://github.com/hashicorp/terraform/issues/16611
terraform {
  backend "s3" {
    bucket         = "terraform-state-farrelllabs-com"
    key            = "app/www/terraform.tfstate"
    region         = "ca-central-1"
    encrypt        = true
    profile        = "farrelllabs"
    dynamodb_table = "terraform-state-farrelllabs-com"
  }
}

variable "env" {}
variable "aws_account_id" {}
variable "aws_region" {}
variable "aws_profile" {}

provider "aws" {
  region  = "${var.aws_region}"
  profile = "${var.aws_profile}"
}

provider "aws" {
  # For Edge API Gateway
  region  = "us-east-1"
  alias   = "edge"
  profile = "${var.aws_profile}"
}

data "aws_acm_certificate" "main" {
  provider = "aws.edge"
  domain   = "www.farrelllabs.com"
  statuses = [
    "ISSUED"
  ]
}

module "s3_test_website" {
  source              = "github.com/willfarrell/terraform-s3-endpoint-module"
  version             = "0.1.0"

  aws_account_id      = "${var.aws_account_id}"
  aws_region          = "${var.aws_region}"
  env                 = "${var.env}"
  name                = "www-farrelllabs-com"
  aliases             = [
    "farrelllabs.com",
    "www.farrelllabs.com"
  ]
  acm_certificate_arn = "${data.aws_acm_certificate.main.arn}"
}
