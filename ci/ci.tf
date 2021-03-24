resource "aws_security_group" "jenkins_inbound_sg" {
  name = "jenkins_inbound"
  description = "Allow access for Jenkins"
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
      Name = "buptlab_jenkins"
  }
}

resource "aws_instance" "jenkins_server" {
  ami = "ami-005c06c6de69aee84"
  instance_type = "t2.micro"
  key_name = "buptlab"
  iam_instance_profile = "JenkinsCIRole"
  user_data = file("ci/install_jenkins.sh")
  vpc_security_group_ids = [aws_security_group.jenkins_inbound_sg.id]
  tags = {
		Name = "Name"	
		Batch = "jenkins_server"
	}
}