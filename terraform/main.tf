variable "awsprops" {
  type = map(string)
  default = {
    region       = "ap-northeast-1"
    vpc          = "vpc-022180xxxxxxxxxxx"                      # replace with your VPC id
    ami          = "ami-0f36dcxxxxxxxxxxx"                      # replace with your ami id
    itype        = "t2.micro"
    subnet       = "subnet-0eebxxxxxxxxxxxx"                    # replace with your subnet id
    publicip     = true
    keyname      = "prome-key"                                  # replace with your keypair name
    secgroupname = "nav-p-sg"                                   
  }
}

provider "aws" {
  region = lookup(var.awsprops, "region")
}

data "aws_security_group" "nav-prome-sg" {                      # replace with your security group name
  id = "sg-08f826afca633c2e5"                                   # replace with your security group id
}


resource "aws_instance" "project-iac" {
  ami                         = lookup(var.awsprops, "ami")
  instance_type               = lookup(var.awsprops, "itype")
  subnet_id                   = lookup(var.awsprops, "subnet") 
  associate_public_ip_address = lookup(var.awsprops, "publicip")
  key_name                    = lookup(var.awsprops, "keyname")
  user_data                   = file("install_prometheus-ext.sh")           # replace user data files from this line

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
  subnet_id                   = lookup(var.awsprops, "subnet") 
  associate_public_ip_address = lookup(var.awsprops, "publicip")
  key_name                    = lookup(var.awsprops, "keyname")
  user_data                   = file("install_node-exporter-ext.sh")        # replace user data files from this line

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
