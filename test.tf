
resource "aws_instance" "ec2" {
    ami= "${var.ami_value}"
    instance_type = "${var.instance_type}"
    availability_zone = "us-east-2a"

 tags = {
     Name = "node-1"
 }   
  
}

