resource "aws_instance" "jenkins-server" {
    ami = data.aws_ami.ubuntu.id
    instance_type = var.instance_type
    key_name = var.instance_keypair
    security_groups = [ aws_security_group.jenkins-sg.id ]
    subnet_id = aws_subnet.nacent-public-subnet-1.id
    iam_instance_profile = aws_iam_instance_profile.Jenkins-instance-profile.name
    associate_public_ip_address = true
    user_data = file("tools.sh")
    tags = {
      Name = "jenkins-server"
    }
}