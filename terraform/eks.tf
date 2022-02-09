# Docs: https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/latest
module "eks" {
  source = "terraform-aws-modules/eks/aws"

  cluster_name                    = "main"
  cluster_version                 = "1.21"
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true

  create_cloudwatch_log_group = false
  cluster_enabled_log_types   = []

  create_cluster_security_group = false
  cluster_security_group_id     = aws_security_group.cluster.id

  cluster_addons = {
    coredns = {
      resolve_conflicts = "OVERWRITE"
    }
    kube-proxy = {}
    vpc-cni = {
      resolve_conflicts = "OVERWRITE"
    }
  }

  cluster_encryption_config = [{
    provider_key_arn = aws_kms_key.cluster.arn
    resources        = ["secrets"]
  }]

  vpc_id     = aws_vpc.main.id
  subnet_ids = concat(aws_subnet.gw.*.id, aws_subnet.prvt.*.id)

  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    ami_type               = "AL2_x86_64"
    disk_size              = 32
    instance_types         = ["t2.medium", "t3.medium", "t3a.medium"]
    vpc_security_group_ids = []
  }

  eks_managed_node_groups = {
    # nodes-test = {
    #   min_size     = 2
    #   max_size     = 2
    #   desired_size = 2

    #   instance_types = ["m6i.large"]
    #   labels = {
    #     Environment = "test"
    #     GithubRepo  = "terraform-aws-eks"
    #     GithubOrg   = "terraform-aws-modules"
    #   }

    #   create_node_security_group = true
    #   # node_security_group_id     = ""
    # }

    nodes = {
      min_size     = 2
      max_size     = 2
      desired_size = 2

      capacity_type  = "SPOT"
      instance_types = ["t2.medium", "t3.medium", "t3a.medium"]
      labels         = {}
      tags           = {}

      subnet_ids = aws_subnet.prvt.*.id

      pre_bootstrap_user_data = <<-EOT
      TMOUT=600; export TMOUT
      EOT

      bootstrap_extra_args = "--kubelet-extra-args '--max-pods=110' '--node-labels=node.kubernetes.io/lifecycle=spot'"

      create_node_security_group = false
      node_security_group_id     = aws_security_group.nodes.id

      post_bootstrap_user_data = <<-EOT
      cd /tmp
      sudo yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
      sudo systemctl enable amazon-ssm-agent
      sudo systemctl start amazon-ssm-agent
      EOT
    }
  }

}

resource "aws_security_group" "cluster" {
  name        = "cluster"
  description = "cluster"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "EKS Cluster"
  }
}

resource "aws_security_group" "nodes" {
  name        = "nodes"
  description = "nodes"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "nodes"
  }
}

resource "aws_kms_key" "cluster" {
  description             = "Encryption for secrets"
  deletion_window_in_days = 10
}
