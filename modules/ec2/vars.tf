

variable "ami_id" {}

variable "instance_type" {}

variable "subnet_id1" {}
variable "subnet_id2" {}


variable "dbname" {
  default = "wordpress"
}

variable "dbusername" {
  default = "wordpress"
}


variable "dbpassword" {
  default = "qniwHfNH;1Tl12"
}


variable "vpc_id" {}
variable "private_subnet_id" {}
