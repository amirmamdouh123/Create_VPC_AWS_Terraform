resource "aws_instance" "ec2" {

  ami = "ami-0325498274077fac5 (64-bit (Arm))"
  instance_type= "t2.micro"
  subnet_id = var.subnet_id

  vpc_security_group_ids = [ var.security_group_id ]  # list of security groups

 tags = {
    Name = "tf-example"
  }

}