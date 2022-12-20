
resource "aws_instance" "redhat-instance" {
  count         = var.instance_count
  ami           = var.ami
  instance_type = var.instance_type
  tags          = merge(map("Name", "ubuntu-vm-${format("%02d", count.index + 1)}"), var.tags)
}

