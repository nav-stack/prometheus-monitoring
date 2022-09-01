variable "awsprops" {
  type = map(string)
  default = {
    region       = "ap-northeast-1"
    vpc          = "vpc-0221805bfb420dcb5"
    ami          = "ami-0f36dcfcc94112ea1"
    itype        = "t2.micro"
    subnet       = "subnet-0eeb3e9267b2d6bbf"
    publicip     = true
    keyname      = "nav-prometheus"
    secgroupname = "nav-p-sg"
  }
}

provider "aws" {
  region = lookup(var.awsprops, "region")
}

data "aws_security_group" "nav-prome-sg" {
  id = "sg-08f826afca633c2e5"
}


resource "aws_instance" "project-iac" {
  ami                         = lookup(var.awsprops, "ami")
  instance_type               = lookup(var.awsprops, "itype")
  subnet_id                   = lookup(var.awsprops, "subnet") #FFXsubnet2
  associate_public_ip_address = lookup(var.awsprops, "publicip")
  key_name                    = lookup(var.awsprops, "keyname")
  user_data                   = file("install_prometheus-ext.sh")

  vpc_security_group_ids = [data.aws_security_group.nav-prome-sg.id]

  tags = {
    Name        = "SERVER01-prome"
    Environment = "DEV"
    OS          = "aml2"
    Managed     = "IAC"
  }

  depends_on = [data.aws_security_group.nav-prome-sg]
}

resource "aws_instance" "project-iac1" {
  ami                         = lookup(var.awsprops, "ami")
  instance_type               = lookup(var.awsprops, "itype")
  subnet_id                   = lookup(var.awsprops, "subnet") #FFXsubnet2
  associate_public_ip_address = lookup(var.awsprops, "publicip")
  key_name                    = lookup(var.awsprops, "keyname")
  user_data                   = file("install_node-exporter-ext.sh")

  vpc_security_group_ids = [data.aws_security_group.nav-prome-sg.id]

  tags = {
    Name        = "SERVER02-node"
    Environment = "DEV"
    OS          = "aml2"
    Managed     = "IAC"
  }

  depends_on = [data.aws_security_group.nav-prome-sg]
}

output "ec2instance" {
  value = [aws_instance.project-iac.public_ip, aws_instance.project-iac1.public_ip]
}