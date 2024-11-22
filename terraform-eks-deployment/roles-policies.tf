data "aws_iam_policy_document" "eks-role-policy" {
   statement {
    sid     = ""
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
  }
} 
  
resource "aws_iam_role" "eks-role" {
    name = "eks-role"
    assume_role_policy = data.aws_iam_policy_document.eks-role-policy.json
}

resource "aws_iam_role_policy_attachment" "eks-role-attachment" {
   for_each = toset([
    "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy",
    "arn:aws:iam::671011067944:policy/EKS-LegacyCloudProviderPolicy",
    "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
   ])
   role = aws_iam_role.eks-role.name
   policy_arn = each.value
}

data "aws_iam_policy_document" "eks-node-role-policy" {
   statement {
    sid     = ""
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
} 

resource "aws_iam_role" "eks-node-role" {
    name = "eks-node-role"
    assume_role_policy = data.aws_iam_policy_document.eks-node-role-policy.json
}

resource "aws_iam_role_policy_attachment" "eks-node-role-policy-attachement" {
    for_each = toset([
        "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
        "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
        "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
    ])
    role = aws_iam_role.eks-node-role.name
    policy_arn = each.value
}

data "aws_iam_policy_document" "test_oidc_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.eks.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:default:aws-test"]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.eks.arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "test_oidc" {
  assume_role_policy = data.aws_iam_policy_document.test_oidc_assume_role_policy.json
  name               = "test-oidc"
}

resource "aws_iam_policy" "test-policy" {
  name = "test-policy"

  policy = jsonencode({
    Statement = [{
      Action = [
        "s3:ListAllMyBuckets",
        "s3:GetBucketLocation"
      ]
      Effect   = "Allow"
      Resource = "arn:aws:s3:::*"
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "test_attach" {
  role       = aws_iam_role.test_oidc.name
  policy_arn = aws_iam_policy.test-policy.arn
}

output "test_policy_arn" {
  value = aws_iam_role.test_oidc.arn
}

