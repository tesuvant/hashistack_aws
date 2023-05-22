resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}

resource "local_file" "hashi_cluster" {
  filename        = "hashi_cluster.pem"
  file_permission = "600"
  content         = tls_private_key.ssh.private_key_pem
}

resource "aws_key_pair" "hashi_ssh" {
  key_name   = "hashi_ssh"
  public_key = tls_private_key.ssh.public_key_openssh
}
