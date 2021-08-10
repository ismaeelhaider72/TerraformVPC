provider "aws" {
  region = "us-east-1"
  shared_credentials_file = "/home/ismaeel/.aws/credentials"
  profile = "default"
}


module "my_vpc" {
  source      = "../modules/vpc"
  vpc_cidr    = "10.0.0.0/16"
  tenancy     = "default"
  vpc_id      = "${module.my_vpc.vpc_id}"
  subnet_cidr1 = "10.0.1.0/24"
  subnet_cidr2 = "10.0.2.0/24"
  subnet_cidr3 = "10.0.3.0/24"
  subnet_cidr4 = "10.0.4.0/24"
  subnet_cidr5 = "10.0.5.0/24"
  subnet_cidr6 = "10.0.6.0/24"
}

module "my_ec2" {
  source        = "../modules/ec2"
  ami_id        = "ami-0c2b8ca1dad447f8a"
  instance_type = "t2.micro"
  subnet_id1     = "${module.my_vpc.subnet_id1}"
  subnet_id2     = "${module.my_vpc.subnet_id2}"
  vpc_id         = "${module.my_vpc.vpc_id}"
  private_subnet_id   =  "${module.my_vpc.private_subnet_id1}"

}
