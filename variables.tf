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

variable "lunch_template_id" {
  description = "NAT instance custom launch template id for ASG."
  type        = string
  default     = null
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

variable "security_group_inbound" {
  description = "Inbound rule for the NAT instance's security group."
  type = list(object({
    cidr_blocks = list(string)
    from_port   = number
    protocol    = string
    to_port     = number
  }))
  default = [{
    cidr_blocks = ["10.0.0.0/8", "172.16.0.0/16", "192.168.0.0/16"]
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    }, {
    cidr_blocks = ["10.0.0.0/8", "172.16.0.0/16", "192.168.0.0/16"]
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
  }]
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

variable "instance_types" {
  description = "Instance types to launch."
  type        = set(string)
  default     = ["t2.micro"]
}

variable "spot" {
  description = "Whether to use spot or on-demand instance."
  type        = bool
  default     = true
}

variable "schedule_scale_up" {
  description = "ASG schedule scale up options."
  type = object({
    enabled    = bool
    recurrence = optional(string)
    time_zone  = optional(string)
  })
  default = {
    enabled = false
  }
}

variable "schedule_scale_down" {
  description = "ASG schedule scale up options."
  type = object({
    enabled    = bool
    recurrence = optional(string)
    time_zone  = optional(string)
  })
  default = {
    enabled    = true
    recurrence = "0 0 * * *"
  }
}

variable "ssm_association_tag" {
  description = "Instance tag to associate for SSM automation with NAT ENI attachment."
  type        = map(string)
  default = {
    "AttachNatEni" = "True"
  }
}
