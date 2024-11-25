
## Create Security Group for Bastion Host
resource "aws_security_group" "bastion-sg" {
     vpc_id = aws_vpc.nacent-vpc.id
     egress = [
        {
        description = "Traffic Allowed Out of VPC"    
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
        prefix_list_ids = []
        security_groups = []
        self = false
        }
    ]
    ingress = [
        {
        description = "Allow Admin Access to Bastion Host Over SSH"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        ipv6_cidr_blocks = []
        prefix_list_ids = []
        security_groups = []
        self = false  
        } 
    ]         
}

resource "aws_security_group" "jenkins-sg" {
  vpc_id      = aws_vpc.nacent-vpc.id
  description = "Allowing Jenkins, Sonarqube, SSH Access"

  ingress = [
     {
      description      = "Allow Jenkins Traffic"
      from_port        = 8080
      to_port          = 8080
      protocol         = "tcp"
      ipv6_cidr_blocks = ["::/0"]
      self             = false
      prefix_list_ids  = []
      security_groups  = []
      cidr_blocks      = ["0.0.0.0/0"]
    },
    {
      description      = "Allow Jenkins Traffic"
      from_port        = 9000
      to_port          = 9000
      protocol         = "tcp"
      ipv6_cidr_blocks = ["::/0"]
      self             = false
      prefix_list_ids  = []
      security_groups  = []
      cidr_blocks      = ["0.0.0.0/0"]
    },
    {
      description      = "Allow SSH Traffic To Jenkins"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      ipv6_cidr_blocks = ["::/0"]
      self             = false
      prefix_list_ids  = []
      security_groups  = []
      cidr_blocks      = ["0.0.0.0/0"]
    }
  ]

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "jenkins-sg"
  }
}



      
