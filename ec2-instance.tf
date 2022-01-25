provider "aws" {
  region     = "us-east-1"
  access_key = "AKIA4NCU4AZET2LQTJ3F"
  secret_key = "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"
}

resource "aws_instance" "webserver-app" {
  ami           = "ami-08e4e35cccc6189f4"
  instance_type = "t2.micro"
  key_name     = "web-key"
  vpc_security_group_ids = [aws_security_group.webapp-sg.id]

  tags = {
    Name = "webserver-app"
  }
}

resource "aws_key_pair" "aws-web-key" {
  key_name   = "web-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCg5flxqO0DuVGymJeW1qYuOgbCF8ONA2efWYNbzU6Gqr2qp2uS7obWL62bhBZbOLAKJcUBtnaAOIk0A09e5U1ETRBjcEWfKdtRsAoFS4f0nE+jP+ADxekg0QU7qmqX0D2Cl2ApFioDhr9W/J31KehAZBZ/gvQY0ktlk+VCj34IB3JEfRagKOmEwYqcGV/HLaZ8K9bpyYcbfbM5TcKtgrmTKhsq+9/aa4R/eBqqvPWl5GTxdJDynU1h07TFNu9W7bMGgPXMDit66otakFhmDAL5Pz/BtUlNB3Wxrwd9qG204uEvrf7w+iHLqbPEADlV0RmpDz8SfBQkA4kOCO/LgbZf root@ip-172-31-44-170.ap-south-1.compute.internal"
}

resource "aws_eip" "webserver-app-eip" {
  instance = aws_instance.webserver-app.id
  vpc      = true
}

resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}

resource "aws_security_group" "webapp-sg" {
  name        = "webappsg"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_default_vpc.default.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
ingress {
    description      = "TLS from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

ingress {
    description      = "TLS from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
ingress {
    description      = "TLS from VPC"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }


  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}


