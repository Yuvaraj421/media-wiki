variable "access_key" {}

variable "secret_key" {}

variable "ssh_public_key" {
    type = string
    description = "your ssh public key"
}
variable "region" {
    type = string
    description = "aws region infra will be provisioned"
    default = "us-east-2"
}

variable "instance_ami" {
  description = "AMI for aws EC2 instance"
  default = "ami-0dd0ccab7e2801812"
}
variable "instance_type" {
  description = "type for aws EC2 instance"
  default = "t2.micro"
}
data "http" "my_public_ip" {
    url = "https://ifconfig.co/json"
    request_headers = {
        Accept = "application/json"
    }
}

locals {
    my_ip = jsondecode(data.http.my_public_ip.body)
}



