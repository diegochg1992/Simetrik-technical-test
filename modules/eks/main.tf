module "eks-controlplane" {
  source                          = "terraform-aws-modules/eks/aws"
  version                         = "19.15.1"
  cluster_name                    = var.eksclustername
  cluster_endpoint_public_access  = true
  cluster_addons = {
  coredns                = {
    most_recent = true
  }
  kube-proxy             = {
    most_recent = true
  }
  vpc-cni                = {
    most_recent = true
  }
}

  vpc_id                          = var.vpc_id
  subnet_ids                      = [var.private_subnet_id1,var.private_subnet_id2]
  control_plane_subnet_ids        = [var.private_subnet_id1,var.private_subnet_id2]

  eks_managed_node_group_defaults = {
  ami_type       = "AL2_x86_64"
  instance_types = ["t3.micro"]
  attach_cluster_primary_security_group = true
}
  eks_managed_node_groups = {
    simetrik-cluster-ng = {
      min_size      = 1
      max_size      = 2
      desired_size  = 1
      instance_types = ["t3.micro"]
      capacity_type = "ON_DEMAND"
    }
  }
}

# # Node Instance Role
# resource "aws_iam_instance_profile" "node_instance_profile" {
#   name = "simetrik-nodeinstance-profile"
#   role = aws_iam_role.node_instance_role.name
# }
# resource "aws_iam_role" "node_instance_role" {
#   name = "simetrik-nodeinstance-role"
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = "sts:AssumeRole"
#         Effect = "Allow"
#         Sid    = ""
#         Principal = {
#           Service = "ec2.amazonaws.com"
#         }
#       },
#     ]
#   })
#   path = "/"
#   managed_policy_arns = ["arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
#     "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
#     "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
#   "arn:aws:iam::aws:policy/AmazonElasticFileSystemReadOnlyAccess"]
# }

# # Node Instance Role Policy
# resource "aws_iam_role_policy" "node_instance_policy" {
#   name = "simetrik-nodeinstance-policy"
#   role = aws_iam_role.node_instance_role.id

#   policy = jsonencode({
#     "Version" : "2012-10-17",
#     "Statement" : [
#       {
#         "Action" : [
#           "autoscaling:Describe*",
#           "elasticloadbalancing:DescribeInstanceHealth",
#           "elasticloadbalancing:DescribeLoadBalancers",
#           "ec2:DescribeLaunchTemplateVersions"
#         ],
#         "Resource" : "*",
#         "Effect" : "Allow"
#       },
#       {
#         "Action" : [
#           "autoscaling:EnableMetricsCollection",
#           "autoscaling:SetDesiredCapacity",
#           "autoscaling:UpdateAutoScalingGroup",
#           "autoscaling:TerminateInstanceInAutoScalingGroup"
#         ],
#         "Resource" : [
#           "arn:aws:autoscaling:us-east-1:400078295185:autoScalingGroup:*:autoScalingGroupName/*",
#           "arn:aws:autoscaling:us-east-1:400078295185:autoScalingGroup:*:autoScalingGroupName/eks-*"
#         ],
#         "Effect" : "Allow"
#       },
#       {
#         "Action" : [
#           "ec2:DescribeVolumes",
#           "ec2:DescribeSnapshots",
#           "ec2:CreateTags",
#           "ec2:CreateVolume",
#           "ec2:CreateSnapshot",
#           "ec2:DeleteSnapshot"
#         ],
#         "Resource" : "*",
#         "Effect" : "Allow"
#       }
#     ]
#   })
# }
# # Creating Launch Templates
# resource "aws_launch_template" "nodegroup-launch-template" {
#   name_prefix            = "simetrik-nodegroup-launch-template"
#   description            = "Launch Template for EKS Nodes"
#   update_default_version = true
#   key_name               = "simetrik-kp"
#   vpc_security_group_ids = [var.node_sg]
# }
# resource "aws_eks_node_group" "nodegroup-od" {
#   depends_on = [
#     module.eks-controlplane
#   ]
#   cluster_name    = var.eksclustername
#   node_group_name = "node-od"
#   node_role_arn   = aws_iam_role.node_instance_role.arn
#   subnet_ids                      = [var.private_subnet_id1,var.private_subnet_id2]
#   capacity_type   = "ON_DEMAND"
#   instance_types = ["t3.micro"]
#   launch_template {
#     id      = aws_launch_template.nodegroup-launch-template.id
#     version = aws_launch_template.nodegroup-launch-template.default_version
#   }

#   labels = {
#     nodegroup         = "simetrik-nodegroup"
#     lifecycle         = "None"
#     PropagateAtLaunch = true
#   }

#   scaling_config {
#     desired_size = 1
#     max_size     = 2
#     min_size     = 1
#   }
# }