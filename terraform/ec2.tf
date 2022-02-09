data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

# TODO: change it to auto scailing groups and use spot instance
resource "aws_instance" "bastion" {
  count                       = length(aws_subnet.gw)
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  key_name                    = aws_key_pair.bastion.key_name
  subnet_id                   = aws_subnet.gw[count.index].id
  vpc_security_group_ids      = [aws_security_group.bastion.id]
  user_data_base64            = base64encode(file("${path.module}/data/initialize_bastion.sh"))

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 10
    delete_on_termination = true
    encrypted             = true
    iops                  = 3000
  }

  tags = {
    Name = "Bastion Host (${aws_subnet.gw[count.index].availability_zone})"
  }
}
