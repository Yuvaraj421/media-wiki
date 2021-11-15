terraform {
  # required_version = "0.12.29"
}

provider "aws" {
  access_key = var.access_key
  secret_key = var.secret_key
  region     = var.region
}

 
 
resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "Ter"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.vpc.id}"
 tags = {
    Name = "Ter"
  }
}
resource "aws_subnet" "subnet_public-1" {
  vpc_id = "${aws_vpc.vpc.id}"
  cidr_block = "10.0.1.0/26"
  map_public_ip_on_launch = "true"
  availability_zone = "us-east-2a"
  tags = {
    Name = "subnet-2"
  }
}
resource "aws_subnet" "subnet_public-2" {
  vpc_id = "${aws_vpc.vpc.id}"
  cidr_block = "10.0.1.64/28"
  map_public_ip_on_launch = "true"
  availability_zone = "us-east-2b"
  tags = {
    Name = "subnet-2"
  }
}


resource "aws_route_table" "rtb_public" {
  vpc_id = "${aws_vpc.vpc.id}"
route {
      cidr_block = "0.0.0.0/0"
      gateway_id = "${aws_internet_gateway.igw.id}"
  }
  tags = {
    Name = "Ter"
  }
}
resource "aws_route_table_association" "rta_subnet_public-1" {
  subnet_id      = "${aws_subnet.subnet_public-1.id}"
  route_table_id = "${aws_route_table.rtb_public.id}"
}
resource "aws_route_table_association" "rta_subnet_public-2" {
  subnet_id      = "${aws_subnet.subnet_public-2.id}"
  route_table_id = "${aws_route_table.rtb_public.id}"
}
resource "aws_key_pair" "mykey" {
  key_name   = "instanceprivatekey"
  public_key = var.ssh_public_key
    
    tags = {
    Name = "Ter"
  }
}

  resource "aws_security_group" "sg_22" {
  name = "sg_22"
  vpc_id = "${aws_vpc.vpc.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${local.my_ip.ip}/32"]
  }
  
  # application
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

}
resource "aws_instance" "mediawiki" {
  ami           = "${var.instance_ami}"
  instance_type = "${var.instance_type}"
  subnet_id = "${aws_subnet.subnet_public-2.id}"
  vpc_security_group_ids = ["${aws_security_group.sg_22.id}"]
  key_name = "${aws_key_pair.mykey.key_name}"
  associate_public_ip_address = true
   provisioner "remote-exec" {
    inline = [
      "echo 'ssh connection'"
    ]
    connection {
      host = self.public_ip
      type = "ssh"
      user = "ec2-user"
      private_key = file("./ssh.private")
    }
  }
  provisioner "local-exec" {
  command = "ansible-playbook  -i '${aws_instance.mediawiki.public_ip},' --private-key './ssh.private' ./app.yaml"
}
 tags = {
    Name = "Ter"
  }
}


  resource "local_file" "tf_ansible_vars_file_new" {
  content = <<-DOC
    # Ansible vars_file containing variable values from Terraform.
    # Generated by Terraform mgmt configuration.

    tf_public_ip: ${aws_instance.mediawiki.public_ip}
    
    DOC
  filename = "./tf_ansible_vars_file.yml"
}



