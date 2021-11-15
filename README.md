# Mediawiki application

Table of contents
1. #### About The Project
2. #### Getting Started
3. #### Usage


## About The Project
### This project is built to host a PHP application in AWS EC2 instance.

### Built With

The project is built using,

* AWS resources

* Terraform

* Ansible

## Getting Started

### Prerequisites

* Create a free tier AWS account.
* Create an IAM user with programmable access and make a note of the access and secret keys.

## Installation

Clone the repo
1. git clone https://github.com/Yuvaraj421/media-wiki.git
2. [Install Terraform](https://www.terraform.io/downloads.html)
3. [Install Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)

# Usage

Standing up the Infrastructure and Installing the application
The infrastructure is setup in AWS using Terraform.

cd into the infrastructure folder in the cloned repository.

Run the following commands in order

* terraform init
 
* terraform plan
 
* terraform apply

