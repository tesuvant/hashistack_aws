resource "aws_instance" "bastion" {
  ami                         = var.ami_id
  instance_type               = "t3.micro"
  subnet_id                   = module.vpc.public_subnets[0]
  associate_public_ip_address = "true"
  vpc_security_group_ids      = [aws_security_group.allow_ssh.id]
  key_name                    = aws_key_pair.hashi_ssh.key_name
  user_data = <<-EOF
                #!bin/bash -x
                SSHKEY="/home/ubuntu/.ssh/id_rsa"
                echo "PubkeyAcceptedKeyTypes=+ssh-rsa" >> /etc/ssh/sshd_config.d/10-insecure-rsa-keysig.conf
                systemctl reload sshd
                echo "${tls_private_key.ssh.private_key_pem}" >> $SSHKEY
                chown ubuntu: $SSHKEY
                chmod 600 $SSHKEY
                apt-add-repository -y ppa:ansible/ansible
                apt-get update
                apt-get -y install ansible
                EOF

  tags = {
    Environment = "test"
    Name = "bastion"
  }
}

resource "aws_instance" "servers" {
  count                  = var.server_node_count
  ami                    = var.ami_id
  instance_type          = var.server_instance_type
  subnet_id              = element(module.vpc.private_subnets, count.index)
  key_name               = aws_key_pair.hashi_ssh.key_name
  vpc_security_group_ids = [aws_security_group.hashi_nodes.id]

  tags = {
    Environment = "test"
    Name = format("server-%d", count.index + 1)
  }
}

resource "aws_instance" "clients" {
  count                  = var.client_node_count
  ami                    = var.ami_id
  instance_type          = var.client_instance_type
  subnet_id              = element(module.vpc.private_subnets, count.index)
  key_name               = aws_key_pair.hashi_ssh.key_name
  vpc_security_group_ids = [aws_security_group.hashi_nodes.id, aws_security_group.allow_helloworld.id]

  tags = {
    Environment = "test"
    Name = format("client-%d", count.index + 1)
  }
}

resource "aws_instance" "traefik" {
  count                  = 3
  ami                    = var.ami_id
  instance_type          = var.traefik_instance_type
  subnet_id              = element(module.vpc.private_subnets, count.index)
  key_name               = aws_key_pair.hashi_ssh.key_name
  vpc_security_group_ids = [aws_security_group.hashi_nodes.id, aws_security_group.allow_http.id]

  tags = {
    Environment = "test"
    Name = format("traefik-%d", count.index + 1)
  }
}

