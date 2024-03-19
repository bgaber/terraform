resource "aws_instance" "demo" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = var.security_group_ids
  subnet_id              = var.subnet_id
  root_block_device {
    delete_on_termination = var.root_block_delete_on_termination
    encrypted             = true
    volume_size           = var.root_block_volume_size
    volume_type           = var.root_block_volume_type
  }
  tags = {
    Name = "Demo Server"
  }
}

output "server_arn" {
  value = aws_instance.demo.arn
}
