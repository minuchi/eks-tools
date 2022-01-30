output "bastion_ips" {
  value = [aws_instance.bastion[0].public_ip, aws_instance.bastion[1].public_ip]

  description = "Bastion IP"
}

output "how_to_connect_to_bastions" {
  value = [
    "ssh -i ${path.module}/data/bastion_ssh_key -p 443 ubuntu@${aws_instance.bastion[0].public_ip}",
    "ssh -i ${path.module}/data/bastion_ssh_key -p 443 ubuntu@${aws_instance.bastion[1].public_ip}",
  ]

  description = "Bastion 서버 접속 명령어"
}
