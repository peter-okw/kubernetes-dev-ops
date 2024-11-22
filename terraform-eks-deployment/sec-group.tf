/*
## Create Security Group for AutoScsaled Instances
resource "aws_security_group" "instances-sg" {
    vpc_id = "${aws_vpc.nacent-vpc.id}"
    egress = [
        {
        description = "Traffic Allowed Out of VPC"    
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
        prefix_list_ids = []
        security_groups = []
        self = false
        } 
    ] 
    ingress = [
        {
            description = "HTTPS into VPC"
            from_port = 443
            to_port = 443
            protocol = "tcp"
            cidr_blocks = ["0.0.0.0/0"]
            ipv6_cidr_blocks = []
            prefix_list_ids = []
            security_groups = [ aws_security_group.nacent-alb-sg.id ]
            self = false    
        },
        {
            description = "HTTP into VPC"
            from_port = 80
            to_port = 80
            protocol = "tcp"
            cidr_blocks = ["0.0.0.0/0"]
            ipv6_cidr_blocks = []
            prefix_list_ids = []
            security_groups = [aws_security_group.nacent-alb-sg.id]
            self = false    
        },
        {
            description = "SSH into VPC"
            from_port = 22
            to_port = 22
            protocol = "tcp"
            cidr_blocks = ["0.0.0.0/0"]
            ipv6_cidr_blocks = []
            prefix_list_ids = []
            security_groups = [aws_security_group.bastion-sg.id]
            self = false    
        },
        {
            description = "HTTP Application Into VPC"
            from_port = 8080
            to_port = 8080
            protocol = "tcp"
            cidr_blocks = [ "0.0.0.0/0" ]
            ipv6_cidr_blocks = []
            prefix_list_ids = []
            security_groups = [aws_security_group.nacent-alb-sg.id]
            self = false    
        }
     ]
}
*/
/*
## Create Security Group for Jenkins Instance
resource "aws_security_group" "jenkins-sg" {
    vpc_id = "${aws_vpc.nacent-vpc.id}"
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
            description = "Allow Jenkins Traffic"
            from_port = 8080
            to_port = 8080
            protocol = "tcp"
            cidr_blocks = ["0.0.0.0/0"]
            ipv6_cidr_blocks = []
            prefix_list_ids = []
            security_groups = []
            self = false  
        },
        {
            description = "ALLOW SSH for Admin"
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

/*
## Security Group for ALB
resource "aws_security_group" "nacent-alb-sg" {
    vpc_id = aws_vpc.nacent-vpc.id
    name = "nacent-alb-sg"
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
*/
## Create Security Group for Bastion Host
resource "aws_security_group" "bastion-sg" {
     vpc_id = data.aws_vpc.selected.id
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

resource "aws_security_group" "eks-cluster-sg" {
     vpc_id = data.aws_vpc.selected.id
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
        description = "Allow Kublet API traffic"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        ipv6_cidr_blocks = []
        prefix_list_ids = []
        security_groups = []
        self = false  
      },
      {
        description = "Allow Kube Proxy Traffic"
        from_port = 1025
        to_port = 65535
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        ipv6_cidr_blocks = []
        prefix_list_ids = []
        security_groups = []
        self = false  
      },
      {
        description = "Allow Kube Proxy Traffic"
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        ipv6_cidr_blocks = []
        prefix_list_ids = []
        security_groups = []
        self = false  
      }
    ]  

}

resource "aws_security_group" "eks-node-ssh-sg" {
     vpc_id = data.aws_vpc.selected.id
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
        description = "Allow Admin Access from Bastion Host Over SSH"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        ipv6_cidr_blocks = []
        prefix_list_ids = []
        security_groups = [aws_security_group.bastion-sg.id]
        self = false  
        }, 
        {
        description = "Allow Kublet API traffic"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        ipv6_cidr_blocks = []
        prefix_list_ids = []
        security_groups = []
        self = false  
      },
      {
        description = "Allow Kube Proxy Traffic"
        from_port = 1025
        to_port = 65535
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        ipv6_cidr_blocks = []
        prefix_list_ids = []
        security_groups = []
        self = false  
      },
      {
        description = "Allow Kube Proxy Traffic"
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        ipv6_cidr_blocks = []
        prefix_list_ids = []
        security_groups = []
        self = false  
      },


      /*
      {
        description = "Allow NodePort Service Traffic"
        from_port = 30000-32767
        to_port = 30000-32767
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        ipv6_cidr_blocks = []
        prefix_list_ids = []
        security_groups = []
        self = false  
      }
      */
    ]  
}