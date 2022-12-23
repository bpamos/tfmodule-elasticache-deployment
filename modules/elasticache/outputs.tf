#### Output variables

#vpc_security_group_ids
output "vpc_security_group_ids" {
  value = [ aws_security_group.sg.id ]
}
