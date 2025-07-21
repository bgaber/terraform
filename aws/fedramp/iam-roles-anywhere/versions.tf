terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0.0, ~> 6.0"
    }
  }

  backend "s3" {
    bucket  = "fedramp-terraform-noc"
    key     = "aws/fedramp/iam-roles-anywhere/tfstate"
    region  = "us-east-1"
    profile = "fedramp-tools-npri"
    #dynamodb_table = "terraform-backend"
  }
}
