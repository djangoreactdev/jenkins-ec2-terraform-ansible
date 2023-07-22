data "aws_ami" "amazon-linux-image" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "server_jenkins" {
  count                       = var.count_ec2_instance
  ami                         = data.aws_ami.amazon-linux-image.id
  instance_type               = var.instance_type
  key_name                    = var.key_name
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.public_subnets[count.index].id
  vpc_security_group_ids      = [aws_security_group.web.id]
  availability_zone           = var.availability_zone[count.index]

  tags = {
    Name = "${var.env}-server_jenkins"
  }

}

resource "null_resource" "configure_server" {
  count = var.count_ec2_instance
  # triggers = {
  #   trigger = aws_instance.server_jenkins[count.index].public_ip
  # }

  provisioner "local-exec" {
    working_dir = "../ansible"
    command     = "pwd && ansible-playbook --inventory ${aws_instance.server_jenkins[count.index].public_ip}, --private-key ${var.ssh_key_private} --user ec2-user jenkins-to-ec2-to-s3-file-backup.yaml"
  }
}

# ==================================== Add from snapshot ===============================================

# resource "aws_volume_attachment" "jenkins_volume_attachment" {
#   device_name = "/dev/xvdf"
#   volume_id   = data.aws_ebs_volume.jenkins_volume.id
#   instance_id = aws_instance.server_jenkins[0].id
# }


# data "aws_ebs_volume" "jenkins_volume" {
#   most_recent = true

#   filter {
#     name   = "volume-type"
#     values = ["gp2"]
#   }

#   filter {
#     name   = "tag:Name"
#     values = ["jenkins"]
#   }
# }


# data "aws_ebs_volume" "prod_volume" {
#   most_recent = true

#   filter {
#     name   = "volume-id"
#     values = ["vol-026e1df5cf9f1ecea"]
#   }
# }

# resource "aws_ebs_snapshot" "production_snapshot" {
#   volume_id = data.aws_ebs_volume.prod_volume.id
# }

# resource "aws_ebs_volume" "from_production_snapshot" {
#   availability_zone = var.availability_zone[0]
#   snapshot_id       = aws_ebs_snapshot.production_snapshot.id
#   size              = 8
# }

# resource "aws_instance" "non_production" {
#   count                       = var.count_ec2_instance
#   ami                         = data.aws_ami.amazon-linux-image.id
#   instance_type               = var.instance_type
#   key_name                    = var.key_name
#   associate_public_ip_address = true
#   subnet_id                   = aws_subnet.public_subnets[count.index].id
#   vpc_security_group_ids      = [aws_security_group.web.id]
#   availability_zone           = var.availability_zone[count.index]
#   tags = {
#     Name   = "MyNew-Server"
#     Server = "MyNew-Server"
#   }
# }

# resource "aws_volume_attachment" "non_production" {
#   device_name = "/dev/xvda"
#   volume_id   = aws_ebs_volume.from_production_snapshot.id
#   instance_id = aws_instance.non_production[0].id
# }
