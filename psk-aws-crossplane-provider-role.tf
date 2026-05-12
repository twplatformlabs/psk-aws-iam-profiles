resource "aws_iam_role" "crossplane_provider" {
  name = "PSKCrossplaneProviderRole"
  path = "/PSKRoles/"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "pods.eks.amazonaws.com" }
      Action    = ["sts:AssumeRole", "sts:TagSession"]
    }]
  })
}

resource "aws_iam_role_policy_attachment" "crossplane_provider" {
  role       = aws_iam_role.crossplane_provider.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

# the aws_eks_pod_identity_association resource is created for each cluster in the control-plane-base pipeline
