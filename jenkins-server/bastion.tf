## Create Bastion Host to Jump off to Private Subnet
resource "aws_instance" "jump-server" {
    ami = data.aws_ami.ubuntu.id
    instance_type = var.instance_type
    key_name = var.instance_keypair
    security_groups = [ aws_security_group.bastion-sg.id ]
    subnet_id = aws_subnet.nacent-public-subnet-1.id
    tags = {
      Name = "Bastion Server"
    }
}