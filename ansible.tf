# Populate Ansible inventory file with hosts
resource "local_file" "ansible_inventory" {
  content = templatefile("${path.root}/inventory.tftpl",
    {
      bastion-id  = aws_instance.bastion.id,
      bastion-ip  = aws_instance.bastion.private_ip,
      bastion-dns = aws_instance.bastion.private_dns,
      clients-dns = aws_instance.clients.*.private_dns,
      clients-ip  = aws_instance.clients.*.private_ip,
      clients-id  = aws_instance.clients.*.id,
      servers-dns = aws_instance.servers.*.private_dns,
      servers-ip  = aws_instance.servers.*.private_ip,
      servers-id  = aws_instance.servers.*.id,
    }
  )
  filename = "${path.root}/ansible/inventory"
}

# Wait for Bastion host to be ready
resource "time_sleep" "awaiting_bastion" {
  depends_on = [aws_instance.bastion]
  create_duration = "30s"

  triggers = {
    "always_run" = timestamp()
  }
}

# Copy ansible dir
# TODO changes to playbook should not be ignored :-/
# https://github.com/hashicorp/terraform/issues/14405
resource "null_resource" "copy_ansible_dir" {
  depends_on = [
    local_file.ansible_inventory,
    time_sleep.awaiting_bastion,
    aws_instance.bastion
  ]

  triggers = {
    "always_run" = timestamp()
  }

  provisioner "file" {
    source      = "${path.root}/ansible/"
    destination = "/home/ubuntu"

    connection {
      type        = "ssh"
      host        = aws_instance.bastion.public_ip
      user        = var.ssh_user
      private_key = tls_private_key.ssh.private_key_pem
      agent       = false
      insecure    = true
    }
  }
}

# Create Ansible vars file
# resource "local_file" "ansible_vars" {
#   content  = <<-DOC

#         server_lb: ${aws_lb.hashi_servers_lb.dns_name}
#         DOC
#   filename = "ansible/ansible_vars.yaml"
# }

# Run Ansible
resource "null_resource" "run_ansible" {
  depends_on = [
    null_resource.copy_ansible_dir,
    aws_instance.servers,
    aws_instance.clients,
    module.vpc,
    aws_instance.bastion,
    time_sleep.awaiting_bastion
  ]

  triggers = {
    always_run = timestamp()
  }

  connection {
    type        = "ssh"
    host        = aws_instance.bastion.public_ip
    user        = var.ssh_user
    private_key = tls_private_key.ssh.private_key_pem
    insecure    = true
    agent       = false
  }

  provisioner "remote-exec" {
    inline = [
      "env|sort",
      "pwd && ls -la && ls -la /home/ubuntu/ansible && ls -la /home/ubuntu/ansible/roles",
      "ansible-galaxy install -r roles/requirements.yaml",
      "ansible-playbook -vv -i inventory play.yaml",
    ]
  }
}
