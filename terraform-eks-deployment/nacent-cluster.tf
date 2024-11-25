## Create EKS Cluster
resource "aws_eks_cluster" "nacent-cluster" {
    name = "nacent-cluster"
    role_arn = aws_iam_role.eks-role.arn

    vpc_config {
      subnet_ids = data.aws_subnets.selected.ids
      security_group_ids = [aws_security_group.eks-cluster-sg.id]
    }
     depends_on = [ aws_iam_role_policy_attachment.eks-role-attachment ]
}

resource "aws_eks_node_group" "nacent-node-group-1" {
    node_group_name = "nacent-node-group-1"
    cluster_name = aws_eks_cluster.nacent-cluster.name
    node_role_arn = aws_iam_role.eks-node-role.arn

    subnet_ids = data.aws_subnets.selected.ids
     
    scaling_config {
      min_size = 3
      max_size = 5
      desired_size = 3
    }
    
    instance_types = [var.instance_type]
    capacity_type = "ON_DEMAND"

    remote_access {
      ec2_ssh_key = var.instance_keypair
      source_security_group_ids = [aws_security_group.bastion-sg.id]
    }
   
    update_config {
      max_unavailable = 1
    }
    labels = {
        role = "general"
    }

    depends_on = [ aws_iam_role_policy_attachment.eks-node-role-policy-attachement ]
}
