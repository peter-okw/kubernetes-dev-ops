# Terraform Block
terraform {
  required_version = "~> 1.7"
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.0"
      
    }
  }
  backend "s3" {
    bucket = "nacent-state-bucket-040724"
    key    = "jenkins/terraform.tfstate"
    region = "eu-west-2"
  }
}
     
  
 
# Provider Block
provider "aws" {
  region = var.aws_region
  
}

/*
Note-1:  AWS Credentials Profile (profile = "default") configured on your local desktop terminal  
$HOME/.aws/credentials
*/

