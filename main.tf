provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "subnet" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
}

resource "aws_instance" "k8s_node" {
  ami           = "ami-12345678"  # Use a suitable Kubernetes-compatible AMI
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.subnet.id
  tags = {
    Name = "k8s-node"
  }
}

provider "kubernetes" {
  host                   = aws_instance.k8s_node.public_ip
  cluster_ca_certificate = file("path/to/ca.crt")
  token                  = file("path/to/token")
}

resource "kubernetes_namespace" "example" {
  metadata {
    name = "production"
  }
}
