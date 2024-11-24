## Declar Existing VPC
data "aws_vpc" "selected" {
  filter {
    name = "tag:Name"
    values = ["nacent-vpc"]
  }
}

data "aws_subnets" "selected" {
  filter {
    name   = "tag:Name"
    values = ["nacent-private-subnet-1","nacent-private-subnet-2","nacent-private-subnet-3"]  
  }
}