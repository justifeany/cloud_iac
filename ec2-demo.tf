provider "aws" {
  profile = "justifeanyi"
  region = "us-east-1"
}

resource "aws_security_group" "server-sg" {
  name = "server-sg"
  description = "Security group for test servers"
  tags = {
	Name = "test-sg"
  }
  ingress {
    from_port = "22"
    to_port = "22"
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = "80"
    to_port = "80"
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 0
    to_port = 0
    protocol = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "server-sg2" {
  name = "server-sg"
  description = "Security group for test servers"
  tags = {
	Name = "test-sg"
  }
  ingress {
    from_port = "22"
    to_port = "22"
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = "80"
    to_port = "80"
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 0
    to_port = 0
    protocol = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "server-sg3" {
  name = "server-sg"
  description = "Security group for test servers"
  tags = {
        Name = "test-sg"
  }
  ingress {
    from_port = "22"
    to_port = "22"
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = "80"
    to_port = "80"
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 0
    to_port = 0
    protocol = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "database-servers" {
  ami = "ami-0ecb62995f68bb549"
  instance_type = "t2.micro"
  key_name = "http-server-key1"
  vpc_security_group_ids = ["${aws_security_group.server-sg.id}"]
  
  user_data =  <<-EOF
    #!/bin/bash
    useradd ansible
    usermod -aG sudo ansible
    echo "ansible:Ansible@123" | sudo chpasswd
    mkdir -p /home/ansible/.ssh
    cd /home/ansible/.ssh
    echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCzYMXekiZM3jzEJbunhR1vQ252toy3iy3tX6ZSJZSzkooPQTR0E50CtZdVPFp8Nb5+0lhlh35SJ5LpjLR2DfyUuGmrjks3Ks4gF8heROZVw82av9MDbhqJa9R/m0lxslG59+3xb0DAOSg5D8+s4PGrRzPBIqlFWNVJvSXoTnAp9M5yY4W4G70uKOiA9zxmqs/R2b4WJ1lwSCyV20aMjs6nxENUyniBwkJKkSXmYG105u4+waPZr2CnR8xgdHzmhJdvWCYDkIKrIGlEUYRGPUgNj+O5gnm8ho3kZVQEx6VOrdcq7uV4R11ccksyAB+2F4E3BXUBpKbsm0eSAjXE+quP ifeanyionuora79@Centos8s1" > authorized_keys
    echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDFDKSQoPdWqkO54V12riipa5lErmcqIUdqYad6odq5QaoeduuMF9sl2V1AGYJh3QRBabYCHv6vN5kGKBFv4/xO8DQe5fS9lmWoAVGidEMdcz7f1rejv7GepuDNq2waf8c440LQgrblKp5istBEo8zMBhQkZrGxB53gqi+zTob7OAXv14V/FRhKAmre3dPchwRPfYWQZ18ptk8aKbg0CiDJ6nFnkn+JA17yQpff0UULzzTzYSrrHI70lYSTdQ3WjOeH232EvJbbjMm0ooDM7utcN5f/gmI+nKXQUNI9sNESg4CvwH7WDG9lmvsQUMNWxShPIiATXIE15Jekdy34CgNb ifeanyionuora79@Ubuntu22s1" >> authorized_keys
    EOF
  
  count = 1
  tags = {
    Name = var.db-server[count.index]
  }
}

resource "aws_instance" "application-servers" {
  ami = "ami-0ecb62995f68bb549"
  instance_type = "t2.micro"
  key_name = "http-server-key1"
  vpc_security_group_ids = ["${aws_security_group.server-sg.id}"]
  
  user_data =  <<-EOF
    #!/bin/bash
    useradd ansible
    usermod -aG sudo ansible
    echo "ansible:Ansible@123" | sudo chpasswd
    mkdir -p /home/ansible/.ssh
    cd /home/ansible/.ssh
    echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCzYMXekiZM3jzEJbunhR1vQ252toy3iy3tX6ZSJZSzkooPQTR0E50CtZdVPFp8Nb5+0lhlh35SJ5LpjLR2DfyUuGmrjks3Ks4gF8heROZVw82av9MDbhqJa9R/m0lxslG59+3xb0DAOSg5D8+s4PGrRzPBIqlFWNVJvSXoTnAp9M5yY4W4G70uKOiA9zxmqs/R2b4WJ1lwSCyV20aMjs6nxENUyniBwkJKkSXmYG105u4+waPZr2CnR8xgdHzmhJdvWCYDkIKrIGlEUYRGPUgNj+O5gnm8ho3kZVQEx6VOrdcq7uV4R11ccksyAB+2F4E3BXUBpKbsm0eSAjXE+quP ifeanyionuora79@Centos8s1" > authorized_keys
    echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDFDKSQoPdWqkO54V12riipa5lErmcqIUdqYad6odq5QaoeduuMF9sl2V1AGYJh3QRBabYCHv6vN5kGKBFv4/xO8DQe5fS9lmWoAVGidEMdcz7f1rejv7GepuDNq2waf8c440LQgrblKp5istBEo8zMBhQkZrGxB53gqi+zTob7OAXv14V/FRhKAmre3dPchwRPfYWQZ18ptk8aKbg0CiDJ6nFnkn+JA17yQpff0UULzzTzYSrrHI70lYSTdQ3WjOeH232EvJbbjMm0ooDM7utcN5f/gmI+nKXQUNI9sNESg4CvwH7WDG9lmvsQUMNWxShPIiATXIE15Jekdy34CgNb ifeanyionuora79@Ubuntu22s1" >> authorized_keys
    EOF
  
  count = 2
  tags = {
    Name = var.app-server[count.index]
  }
}
