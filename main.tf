module "firstVpc" {
    source = "./vpc_module"
    vpc_name = "firstVPC"
    vpc_cidr = var.vpc_cidr
}

module "internet_gateway" {
    source = "./internet_gateway_module"
    vpc_id = module.firstVpc.vpc_id
  
}


module "public_subnet" {
    source = "./subnet_module"
    vpc_id_subnet = module.firstVpc.vpc_id
    vpc_name_subnet = "firstVPC"
    subnet_cidr = var.public_cidr
    isPulbic = true

}

module "public_route_table" {           //assosiated to the public subnet
  source = "./route_table"
  vpc_id = module.firstVpc.vpc_id
  route_table_name = "public_route_table"

}

module "route_for_public_route_table" {        //access internet for public subnet
  source = "./route"
  vpc_id = module.firstVpc.vpc_id
  route_table_id = module.public_route_table.route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = module.internet_gateway.internet_gateway_id
}

resource "aws_route_table_association" "assosiate_route_table_to_public_subnet" {
   route_table_id = module.public_route_table.route_table_id
   subnet_id = module.public_subnet.subnet_id
}


module "public_security_group" {
    source = "./security_group_module"
    vpc_id = module.firstVpc.vpc_id
    security_name = "my_public_security_group"
  
}

module "public_inbound" {
  source = "./security_group_module/inbound_module"
  security_group_id = module.public_security_group.security_group_id
  port_inbound = -1                      //ai 7d mmkn yklmi
  IP_inbound = "0.0.0.0/0"
}

module "public_outbound" {
  source = "./security_group_module/outbound_module"
  security_group_id = module.public_security_group.security_group_id
  security_group_cidr = "0.0.0.0/0"           // request ani one
  security_group_port = -1                    // request all ports
  security_group_protcol = "tcp"
}








module "private_subnet" {
    source = "./subnet_module"
    vpc_id_subnet = module.firstVpc.vpc_id
    vpc_name_subnet = "firstVPC"
    subnet_cidr = var.private_cidr
    isPulbic = false
}

module "private_route_table" {           //assosiated to public subnet
  source = "./route_table"
  vpc_id = module.firstVpc.vpc_id
  route_table_name = "private_route_table"

}


resource "aws_route_table_association" "assosiate_route_table_to_private_subnet" {
   route_table_id = module.private_route_table.route_table_id
   subnet_id = module.private_subnet.subnet_id
}

module "private_security_group" {
    source = "./security_group_module"
    vpc_id = module.firstVpc.vpc_id
    security_name = "my-private-security-group"

}


module "private_inbound_shh" {
  source = "./security_group_module/inbound_module"
  security_group_id = module.private_security_group.security_group_id
  port_inbound = 22
  IP_inbound = var.IP_inbound
}

module "private_inbound_webapp" {
  source = "./security_group_module/inbound_module"
  security_group_id = module.private_security_group.security_group_id
  port_inbound = 3000
  IP_inbound = var.IP_inbound
}

module "private_outbound" {
  source = "./security_group_module/outbound_module"
  security_group_id = module.private_security_group.security_group_id
  security_group_cidr = var.private_cidr
  security_group_port = -1                    // request all ports
  security_group_protcol = "tcp"
}







module "ec2" {
    source = "./EC2_module"
    security_group_id = module.public_security_group.security_group_id
    subnet_id = module.private_subnet.subnet_id
    vpc_id = module.firstVpc.vpc_id
}



output "internet_gateway" {
  value = module.internet_gateway.internet_gateway_id
}