resource "aws_vpc_security_group_egress_rule" "security_group_egress" {

  security_group_id = var.security_group_id
  cidr_ipv4 = var.IP_inbound           # "0.0.0.0/0"
  ip_protocol       = var.port_inbound # semantically equivalent to all ports

}