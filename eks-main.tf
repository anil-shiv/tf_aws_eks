locals {
  workstation-external-cidr = "0.0.0.0/0"
}


resource "aws_iam_role" "shiv_cluster_role" {
  name = "${var.CLUSTER_NAME}_cluster_role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "shiv_cluster_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.shiv_cluster_role.name
}

resource "aws_iam_role_policy_attachment" "shiv_cluster_AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.shiv_cluster_role.name
}


resource "aws_eks_cluster" "eks" {
  name     = var.CLUSTER_NAME
  role_arn = aws_iam_role.shiv_cluster_role.arn

  vpc_config {
    security_group_ids = [aws_security_group.shiv_cluster_sg.id]
    subnet_ids         = aws_subnet.shiv_vpc_public_subnet[*].id
  }

  depends_on = [
    aws_iam_role_policy_attachment.shiv_cluster_AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.shiv_cluster_AmazonEKSVPCResourceController,
  ]
}