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

  tags        = merge(map("Name", "ubuntu-vm-${format("%02d", count.index + 1)}"), var.tags)
  volume_tags = merge(map("Name", "ubuntu-vm-${format("%02d", count.index + 1)}"), var.tags)


  provisioner "remote-exec" {
    inline = [
      "sudo apt update -y",
      "sudo apt install nginx -y",
      "sudo systemctl enable nginx",
      "sudo systemctl start nginx",
    ]
  }

  connection {
    host        = coalesce(self.public_ip, self.private_ip)
    type        = "ssh"
    user        = "ubuntu"
    agent       = true
    private_key = file("rsa_id")
    timeout     = "3"
  }

  lifecycle {
    ignore_changes        = [ami]
    create_before_destroy = true
  }
}
#### Create Elastic block volume 
resource "aws_ebs_volume" "ubuntu-volume" {
  count             = var.instance_count
  availability_zone = element(aws_instance.ubuntu-instance.*.availability_zone, count.index)
  size              = var.ebs_volume_size
  type              = var.ebs_volume_type
  tags              = merge(map("Name", "ubuntu-ebs-volume-${format("%02d", count.index + 1)}"), var.tags)
}

#### Create Elastic block volume attachment
resource "aws_volume_attachment" "ubuntu-volume-attachment" {
  count       = var.instance_count
  device_name = "/dev/xvdg"
  volume_id   = element(aws_ebs_volume.ubuntu-volume.*.id, count.index)
  instance_id = element(aws_instance.ubuntu-instance.*.id, count.index)

  lifecycle {
    ignore_changes = [
      instance_id,
      volume_id,
    ]
  }

  connection {
    type        = "ssh"
    user        = var.ssh_user
    host        = element(aws_instance.ubuntu-instance.*.public_ip, count.index)
    agent       = false
    private_key = var.private_key
  }

  # Prepare the EBS volume for storage
  provisioner "file" {
    source      = "storage_setup.sh"
    destination = "/tmp/storage_setup.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /tmp/storage_setup.sh",
      "sudo /tmp/storage_setup.sh",
    ]
  }

}

