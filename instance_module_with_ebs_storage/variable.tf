##################################
#### Instance Level variables####
#################################

variable "subnets" {
  type        = list(any)
  description = "Internal/Private subnets ID's"
  default     = []
}

variable "tags" {
  type        = map(any)
  description = "The AWS tags to be applied to resources"
}
variable "environment" {
  type        = string
  description = "The environment name, one of dev,staging,prod"
}
variable "region" {
  type        = string
  description = "The region to deploy resources in."
  default     = "us-west-2"
}
variable "instance_profile" {
  description = "The IAM instance profile for the ec2 instance"
  type        = string
  default     = ""
}
variable "ami" {}
variable "key_name" {}
variable "root_block_device_size" {}
variable "root_block_device_type" {}
# variable "ebs_volume_size" {}
# variable "ebs_volume_type" {}
variable "ssh_user" {}
variable "private_key" {}
variable "ssh_public_key" {}
variable "vpc_id" {}
variable "instance_type" {}
variable "instance_count" {}
variable "ebs_block_device" {}
variable "staging_ebs_block_device" {}
variable "ebs_termination" {}