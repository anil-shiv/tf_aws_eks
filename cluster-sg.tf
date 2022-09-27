resource "aws_security_group" "shiv_cluster_sg" {
  name        = "${var.CLUSTER_NAME}_sg"
  description = "Cluster communication with worker nodes"
  vpc_id      = aws_vpc.shiv_vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.CLUSTER_NAME}_sg"
  }
}

resource "aws_security_group_rule" "shiv_cluster_ingress_workstation_https" {
  cidr_blocks       = [local.workstation-external-cidr]
  description       = "Allow workstation to communicate with the cluster API Server"
  from_port         = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.shiv_cluster_sg.id
  to_port           = 443
  type              = "ingress"
}