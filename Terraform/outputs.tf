output "web_instance_id" {
  value = aws_instance.web.id
}

output "web_private_ip" {
  value = aws_instance.web.private_ip
}

output "web_public_ip" {
  value = aws_instance.web.public_ip
}

output "ansible_private_ip" {
  value = aws_instance.ansible.private_ip
}

output "monitoring_private_ip" {
  value = aws_instance.monitoring.private_ip
}

output "web_elastic_ip" {
  value = aws_eip.web_eip.public_ip
}