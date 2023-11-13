# This data store is holding the most recent ubuntu 20.04 image
data "aws_ami" "ubuntu" {
   most_recent = "true"

   filter {
      name = "name"
      values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
   }

   filter {
      name = "virtualization-type"
      values = ["hvm"]
   }

   owners = ["099720109477"]
}

data "aws_key_pair" "existing_key_pair" {
  key_name = "my-ec2-keypair"  # Replace with the name of your existing key pair
}

# Creating an EC2 instance called jenkins_server
resource "aws_instance" "jenkins_server" {
   # Setting the AMI to the ID of the Ubuntu 20.04 AMI from the data store
   ami = data.aws_ami.ubuntu.id

   # Setting the subnet to the public subnet we created
   subnet_id = aws_subnet.public_subnet1.id
   # Setting the instance type to t2.micro
   instance_type = "t2.large"
  associate_public_ip_address = true
   # Setting the security group to the security group we created
   vpc_security_group_ids = [aws_security_group.my_instance_SG.id]

   # Setting the key pair name to the key pair we created
   key_name = data.aws_key_pair.existing_key_pair.key_name

   # Setting the user data to the bash file called install_jenkins.sh
   user_data = file("jenkins.sh")

   # Setting the Name tag to jenkins_server
   tags = {
      Name = "jenkins_server"
   }
}

# Creating an Elastic IP called jenkins_eip
resource "aws_eip" "jenkins_eip" {
   # Attaching it to the jenkins_server EC2 instance
  instance = aws_instance.jenkins_server.id

   # Making sure it is inside the VPC
  # domain = "vpc"

   # Setting the tag Name to jenkins_eip
   tags = {
     # Name = "jenkins_eip"
   }
}
