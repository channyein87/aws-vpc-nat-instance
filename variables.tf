variable "name_prefix" {
  description = "Name prefix for all the resources as identifier."
  type        = string
  default     = null
}

variable "name_suffix" {
  description = "Name suffix for all the resources as identifier."
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags for all the resources."
  type        = map(string)
  default     = {}
}

variable "vpc_id" {
  description = "VPC Id."
  type        = string
}

variable "public_subnet_id" {
  description = "Public subnet id of the NAT instance."
  type        = string
}

variable "route_table_ids" {
  description = "List of route table ids to use with NAT instance."
  type        = any
}

variable "security_group_inbound_cidrs" {
  description = "Addtional inbound CIDR ranges to NAT instance."
  type        = list(string)
  default     = []
}

variable "ebs" {
  description = "Specify EBS volume custom properties to attach to the instance."
  type = object({
    delete_on_termination = optional(bool)
    encrypted             = optional(bool)
    iops                  = optional(number)
    throughput            = optional(number)
    kms_key_id            = optional(string)
    volume_size           = optional(number)
    volume_type           = optional(string)
  })
  default = {
    delete_on_termination = true
    encrypted             = true
    volume_size           = 8
    volume_type           = "gp3"
  }
}

variable "key_pair_name" {
  description = "Key pair to SSH to the NAT instance."
  type        = string
  default     = null
}

variable "iam_instance_profile" {
  description = "Name of the IAM instance profile."
  type        = string
  default     = null
}

variable "instance_type" {
  description = "Instance type to launch."
  type        = string
  default     = "t3.micro"
}

variable "spot" {
  description = "Whether to use spot or on-demand instance."
  type        = bool
  default     = false
}
