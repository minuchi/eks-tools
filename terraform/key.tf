resource "aws_key_pair" "bastion" {
  key_name   = "bastion"
  public_key = file("${path.module}/data/bastion_ssh_key.pub")
}

resource "aws_key_pair" "ec2" {
  key_name   = "ec2"
  public_key = file("${path.module}/data/ec2_ssh_key.pub")
}
