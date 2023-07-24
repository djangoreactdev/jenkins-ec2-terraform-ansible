resource "null_resource" "configure_server" {
  count = var.count_ec2_instance
  triggers = {
    trigger = aws_instance.server_jenkins[count.index].public_ip
  }

  provisioner "local-exec" {
    working_dir = "../ansible"
    command     = "pwd && ansible-playbook --inventory ${aws_instance.server_jenkins[count.index].public_ip}, --private-key ${var.ssh_key_private} --user ec2-user ${var.file_ansible_playbook}"
  }
}
