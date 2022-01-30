output "bastion_instance_ip_addr" {
  value = aws_instance.bastion.public_ip
}

output "how_to_connect_to_bastion" {
  value = "ssh -i ${path.module}/data/bastion_ssh_key -p 443 ubuntu@${aws_instance.bastion.public_ip}"
}
