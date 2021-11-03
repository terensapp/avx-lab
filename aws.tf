##################################################################
# Data source to get AMI details
##################################################################
data "aws_ami" "ubuntu" {
  provider    = aws.us-east-2
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # Canonical
}

locals {
  host_user_data = <<EOF
#!/bin/bash
sudo hostnamectl set-hostname "BU1-Bastion"
sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
sudo echo 'ubuntu:${var.host_password}' | /usr/sbin/chpasswd
sudo apt update -y
sudo apt upgrade -y
sudo apt-get -y install traceroute unzip build-essential git gcc hping3 apache2 net-tools
sudo apt autoremove
sudo /etc/init.d/ssh restart
sudo echo "<html><h1>Aviatrix is awesome</h1></html>" > /var/www/html/index.html 
EOF
}

module "security_group_hosts" {
  for_each =  {for key, value in var.gateways.spoke: key => value if coalesce(value.attach_host,false)}
  
    source              = "terraform-aws-modules/security-group/aws"
    version             = "~> 3.0"
    name                = "test_host_sg"
    description         = "Security group for example usage with EC2 instance"
    vpc_id              = module.aws_spoke["${each.key}"].vpc.vpc_id
    ingress_cidr_blocks = ["0.0.0.0/0"]
    ingress_rules       = ["http-80-tcp", "ssh-tcp", "all-icmp"]
    egress_rules        = ["all-all"]
    #region              = "${lookup(each.value, "region")}"
    providers = {
      aws = aws.${lookup(each.value, "region")}
    }

    depends_on = [module.aws_transit, module.aws_spoke]
}

module "aws_spoke_hosts" {
  for_each =  {for key, value in var.gateways.spoke: key => value if coalesce(value.attach_host,false)}
    source                      = "terraform-aws-modules/ec2-instance/aws"
    version                     = "2.21.0"
    instance_type               = var.aws_test_instance_size
    name                        = "${each.key}-host"
    ami                         = data.aws_ami.ubuntu.id
    key_name                    = var.ec2_key_name
    instance_count              = 1
    subnet_id                   = module.aws_spoke["${each.key}"].vpc.public_subnets[0].subnet_id
    vpc_security_group_ids      = [module.security_group_hosts["${each.key}"].this_security_group_id]
    associate_public_ip_address = true
    user_data_base64            = base64encode(local.host_user_data)
    #region                      = "${lookup(each.value, "region")}"
    providers = {
      aws = aws.${lookup(each.value, "region")}
    }

    depends_on = [module.aws_transit, module.aws_spoke, module.security_group_hosts]
}

#output "aws_spoke1_bastion_public_ip" {
#  value = module.aws_spoke1_bastion.public_ip
#}