locals {
  name_prefix = "chek"
}

## EC2 Instance

resource "aws_instance" "chek-ec2-ebs" {
  ami                    = "ami-04c913012f8977029"
  instance_type          = "t2.micro"
  subnet_id              = data.aws_subnets.public.ids[0]
  vpc_security_group_ids = [aws_security_group.chek-ebs-sg.id]
  associate_public_ip_address = true
  availability_zone = "ap-southeast-1c"


  tags = {
    Name = "${local.name_prefix}-ec2-ebs"
  }
}

resource "aws_security_group" "chek-ebs-sg" {
  name        = "${local.name_prefix}-ebs-sg"
  description = "Allow SSH inbound"
  vpc_id      = data.aws_vpc.selected.id
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_ipv4" {
  security_group_id = aws_security_group.chek-ebs-sg.id
  cidr_ipv4         = "0.0.0.0/0"  
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

## EBS

resource "aws_ebs_volume" "chek-ebs-attached" {
  availability_zone = "ap-southeast-1c"
  size              = 1

}

resource "aws_volume_attachment" "chek-ebs-attached" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.chek-ebs-attached.id
  instance_id = aws_instance.chek-ec2-ebs.id
}
