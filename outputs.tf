output "bastion_public_ip" {
  value = ""
}

# Fix for TF Cloud
# https://discuss.hashicorp.com/t/tls-private-key-get-private-key-for-use-with-tools-putty-or-ansible/38429
output "private_key" {
  value     = tls_private_key.ssh.private_key_pem
  sensitive = true
}

output "CONVERT_LINE_BREAKS" {
  value = <<TXT1
  ### CONVERT LINE BREAKS
  echo "...-----END RSA PRIVATE KEY-----\n" | gsed 's/\\n/\
  /g'
    TXT1
}

output "ACCESS_BASTION" {
  value = <<TXT2
  ### BASTION
  ssh -i ${local_file.hashi_cluster.filename} ${var.ssh_user}@${aws_instance.bastion.public_ip}
    TXT2
}

output "PORT_FORWARDING_CONSUL" {
  value = <<TXT3
  ### PORT FORWARDING TO ACCESS CONSUL
  ssh -i ${local_file.hashi_cluster.filename} -J ${var.ssh_user}@${aws_instance.bastion.public_ip} ${var.ssh_user}@${aws_instance.servers.0.private_ip} -L 8500:127.0.0.1:8500
  point browser to...
  127.0.0.1:8500
    TXT3
}

output "PORT_FORWARDING_TRAEFIK" {
  value = <<TXT3
  ### PORT FORWARDING TO ACCESS TRAEFIK
  ssh -i ${local_file.hashi_cluster.filename} -J ${var.ssh_user}@${aws_instance.bastion.public_ip} ${var.ssh_user}@${aws_instance.traefik.0.private_ip} -L 8080:127.0.0.1:8080
  point browser to...
  127.0.0.1:8080
    TXT3
}