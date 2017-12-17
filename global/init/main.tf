variable "name" {
  default = "farrelllabs-com"
}
variable "aws_region" {
  default = "ca-central-1"
}
variable "aws_profile" {
  default = "farrelllabs"
}

provider "aws" {
  region  = "${var.aws_region}"
  profile = "${var.aws_profile}"
}

module "state" {
  source = "github.com/willfarrell/terraform-state-module"
  version = "0.0.1"

  name = "farrelllabs-com"
  aws_region = "${var.aws_region}"
  aws_profile = "${var.aws_profile}"
}

output "backend_s3_bucket" {
  value = "${module.state.backend_s3_bucket}"
}
output "backend_s3_bucket_logs" {
  value = "${module.state.backend_s3_bucket_logs}"
}
output "backend_s3_dynamodb_table" {
  value = "${module.state.backend_s3_dynamodb_table}"
}
