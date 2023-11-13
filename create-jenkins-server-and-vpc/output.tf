output "jenkins-public-ip" {
  value = aws_instance.jenkins_server.public_ip
}

output "jenkins_eip" {
  value = aws_eip.jenkins_eip.public_ip
}



