data "template_cloudinit_config" "config_db" {
  gzip          = false
  base64_encode = false  #first part of local config file
  part {
    content_type = "text/x-shellscript"
    content      = <<-EOF
    #!/bin/bash 
    sudo su
    sudo wget https://dev.mysql.com/get/mysql57-community-release-el7-11.noarch.rpm
    sudo yum localinstall mysql57-community-release-el7-11.noarch.rpm -y
    yum install -y mysql-community-server
    systemctl enable mysqld
    systemctl start mysqld
    mysql -u root "-p$(grep -oP '(?<=root@localhost\: )\S+' /var/log/mysqld.log)" -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${var.dbpassword}'" --connect-expired-password
    mysql -u root "-p${var.dbpassword}" -e "CREATE DATABASE ${var.dbname}"
    mysql -u root "-p${var.dbpassword}" -e "CREATE USER '${var.dbusername}'@'%' IDENTIFIED BY '${var.dbpassword}'"
    mysql -u root "-p${var.dbpassword}" -e "GRANT ALL PRIVILEGES ON *.* TO '${var.dbusername}'@'%'"
    mysql -u root "-p${var.dbpassword}" -e "FLUSH PRIVILEGES"    
    EOF
  }

}


resource "aws_instance" "example" {
  ami           = var.ami_id
  instance_type = "${var.instance_type}"

  # the VPC subnet
  subnet_id = "${var.private_subnet_id}"

  # the security group
  vpc_security_group_ids = [aws_security_group.db-securitygroup.id]

  # the public SSH key
  key_name = "ismaeelkeypair"
  user_data = data.template_cloudinit_config.config_db.rendered

  tags = {
    Name = "ismaeelprivateDBInstance"
  }


}
