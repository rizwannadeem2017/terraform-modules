resource "aws_security_group" "ubuntu-sg" {
  name   = "ubuntu-sg-${var.environment}"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  count = var.instance_count
  tags  = merge(map("Name", "ubuntu-sg-${var.environment}"), var.tags)
}

#### Key_pair 
resource "aws_key_pair" "key-pair" {
  key_name   = "auth_key"
  public_key = var.ssh_public_key
  tags       = merge(map("Name", "ubuntu-kp-${var.environment}"), var.tags)
}


##### aws_instance 
resource "aws_instance" "ubuntu-instance" {
  count                       = var.instance_count
  ami                         = var.ami
  instance_type               = var.instance_type
  key_name                    = var.key_name
  associate_public_ip_address = true
  subnet_id                   = element(var.subnets, count.index)
  vpc_security_group_ids      = [aws_security_group.ubuntu-sg[0].id]
  #iam_instance_profile        = var.instance_profile

  root_block_device {
    volume_type = var.root_block_device_type
    volume_size = var.root_block_device_size
  }

  dynamic "ebs_block_device" {
    for_each = var.ebs_block_device
    content {
      device_name           = ebs_block_device.value.device_name   #"/dev/xvdx"
      volume_type           = "gp3"
      volume_size           = ebs_block_device.value.volume_size
      delete_on_termination = var.ebs_termination
    }
  }

  # ebs_block_device {
  # device_name           = "/dev/xvdx"
  # volume_type           = var.ebs_volume_type
  # volume_size           = var.ebs_volume_size
  # delete_on_termination = true
  # }

  # ebs_block_device {
  # device_name           = "/dev/xvdy"
  # volume_type           = var.ebs_volume_type
  # volume_size           = var.ebs_volume_size
  # delete_on_termination = true
  # }


  tags        = merge(map("Name", "ubuntu-vm-${format("%02d", count.index + 1)}"), var.tags)
  volume_tags = merge(map("Name", "ubuntu-vm-${format("%02d", count.index + 1)}"), var.tags)


  # provisioner "remote-exec" {
  #   inline = [
  #     "sudo apt update -y",
  #     "sudo apt install nginx -y",
  #     "sudo systemctl enable nginx",
  #     "sudo systemctl start nginx",
  #   ]
  # }

  # connection {
  #   host        = coalesce(self.public_ip, self.private_ip)
  #   type        = "ssh"
  #   user        = "ubuntu"
  #   agent       = false
  #   private_key = file("${path.module}/auth_key")
  #   timeout     = "3"
  # }

  # lifecycle {
  #   ignore_changes        = [ami]
  #   create_before_destroy = true
  # }
}

##############################################################################################################################
###################################### Test Purpose #################################
##############################################################################################################################



##############################################################################################################################
###################################### Test End #################################
##############################################################################################################################



# connection {
#   type        = "ssh"
#   user        = var.ssh_user
#   host        = element(aws_instance.ubuntu-instance.*.public_ip, count.index)
#   agent       = false
#   private_key = var.private_key
# }

# # Prepare the EBS volume for storage
# provisioner "file" {
#   source      = "${path.module}/storage_setup.sh"
#   destination = "/tmp/storage_setup.sh"
# }

# provisioner "remote-exec" {
#   inline = [
#     "sudo chmod +x /tmp/storage_setup.sh",
#     "sudo /tmp/storage_setup.sh",
#   ]
# }

# }

