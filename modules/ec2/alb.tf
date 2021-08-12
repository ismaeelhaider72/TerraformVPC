resource "aws_lb" "app" {  
  name               = "mainapplb"  
  internal           = false  
  load_balancer_type = "application" 
  subnets            = ["${var.public_subnet_id1}","${var.public_subnet_id2}"]
  security_groups    = [aws_security_group.elb-securitygroup.id]


  }

 resource "aws_lb_listener" "app" {  
  load_balancer_arn = aws_lb.app.arn  
  port              = "80" 
  protocol          = "HTTP"
  default_action {  
    type             = "forward"    
    target_group_arn = aws_lb_target_group.blue.arn  
    }

    }





resource "aws_lb_target_group" "blue" {  
    name     = "ismaeeltargergrout"  
    port     = 80  
    protocol = "HTTP" 
    vpc_id   ="${var.vpc_id}"
    health_check {    
    port     = 80    
    protocol = "HTTP"  
    timeout  = 5   
    interval = 10 
     }
}

