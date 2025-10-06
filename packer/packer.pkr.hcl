packer {
  required_plugins {
    amazon = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/amazon"
    }
  }
}
variable "aws_region" {
  type    = string
  default = "ap-southeast-2"
}

variable "ami_name" {
  type    = string
  default = "nat-instance-al2023-{{timestamp}}"
}

source "amazon-ebs" "nat_instance" {
  region                  = var.aws_region
  instance_type           = "t3.micro"
  ami_name                = var.ami_name
  source_ami_filter {
    filters = {
      name                = "al2023-ami-*-x86_64"
      virtualization-type = "hvm"
      root-device-type    = "ebs"
    }
    owners      = ["137112412989"]
    most_recent = true
  }
  ssh_username = "ec2-user"
}

build {
  sources = ["source.amazon-ebs.nat_instance"]

  provisioner "shell" {
    inline = [
      "sudo yum install iptables-services -y",
      "sudo systemctl enable iptables",
      "sudo systemctl start iptables",
      "echo 'net.ipv4.ip_forward=1' | sudo tee /etc/sysctl.d/custom-ip-forwarding.conf",
      "sudo sysctl -p /etc/sysctl.d/custom-ip-forwarding.conf",
      "sudo cat /etc/sysctl.d/custom-ip-forwarding.conf",
      "netstat -i",
      "sudo /sbin/iptables -t nat -A POSTROUTING -o ens5 -j MASQUERADE",
      "sudo /sbin/iptables -F FORWARD",
      "sudo service iptables save"
    ]
  }
}
