# output db url, ecr url in order to change the config for TechTestApp docker container

output "vpc_id" {
  description = "The ID of the VPC"
  value = aws_vpc.octopus-vpc.id
}
output "public_subnets" {
  description = "List of IDs of public subnets"
  value = ["${aws_subnet.octopus-public-subnet.*.id}"]
}
output "private_subnets" {
  description = "List of IDs of private subnets"
  value = ["${aws_subnet.octopus-private-subnet.*.id}"]
}
