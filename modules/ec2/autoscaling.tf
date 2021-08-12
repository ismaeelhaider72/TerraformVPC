data "template_cloudinit_config" "config" {
  gzip          = false
  base64_encode = false  #first part of local config file
  part {
    content_type = "text/x-shellscript"
    content      = <<-EOF
    #!/bin/bash 
    sudo su
    yum install httpd php-mysql -y
    amazon-linux-extras install -y php7.3
    cd /var/www/html
    wget https://wordpress.org/latest.tar.gz
    tar -xzf latest.tar.gz
    cp -r wordpress/* /var/www/html/
    rm -rf wordpress
    rm -rf latest.tar.gz
    chmod -R 755 wp-content
    chown -R apache:apache wp-content
    service httpd start
    chkconfig httpd on
    cd /var/www/html
    cp wp-config-sample.php wp-config.php   
    sed -i "s/database_name_here/${var.dbname}/g" wp-config.php
    sed -i "s/username_here/${var.dbusername}/g" wp-config.php
    sed -i "s/password_here/${var.dbpassword}/g" wp-config.php
    sed -i "s/localhost/${aws_instance.example.private_ip}/g" wp-config.php
    EOF
  }

}


resource "aws_autoscaling_group" "autoscalling_group_config" {
  name = "autoscaling"
  max_size = 3
  min_size = 2
#  health_check_grace_period = 300
#  health_check_type = "EC2"
  desired_capacity = 3
  force_delete = true
  vpc_zone_identifier = ["${var.public_subnet_id1}","${var.public_subnet_id2}"]
  launch_configuration = aws_launch_configuration.launch-configuration.name
 
  lifecycle {
    create_before_destroy = true
  }
}



resource"aws_launch_configuration" "launch-configuration" {
  name = "launchConfiguration234"
  image_id = "${var.ami_id}"
  instance_type = "${var.instance_type}"
  key_name = "ismaeelkeypair"
  security_groups = [aws_security_group.allow-ssh.id]
  user_data = data.template_cloudinit_config.config.rendered
                  
}


resource "aws_autoscaling_attachment" "asg_attachment_bar" {
  autoscaling_group_name = aws_autoscaling_group.autoscalling_group_config.id
  alb_target_group_arn   = aws_lb_target_group.blue.arn
}

