variable "AWS_REGION" {
  default = "ap-south-1"
}

variable "CLUSTER_NAME" {
  default = "shivaanta-eks-demo"
  type    = string
}

variable "NUMBER_OF_PUBLIC_SUBNET" {
  default = 2
  type    = number
}