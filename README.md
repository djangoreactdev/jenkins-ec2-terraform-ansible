# Install jenkins in docker container to ec2 instance usin terraform and ansible

1. chenge file terraform/tfvars.example -> terraform.tfvars and setup all parameters
2. chenge file ansible/project-vars-example -> project-vars and setup all parameters
3. edit file terraform/run-ansible-playbook.tf 
4. navigate to terraform - cd terraform
5. terraform init
6. terraform apply - and agree write yes

#### your jenkins have link - your_ip_aws:8080 