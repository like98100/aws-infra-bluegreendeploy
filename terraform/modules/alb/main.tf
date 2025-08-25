# Application Load Balancer
resource "aws_lb" "main" {
  name               = "${var.project_name}-${var.environment}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.security_group_id]
  subnets            = var.public_subnets

  enable_deletion_protection = false

  tags = merge(var.tags, {
    Name = "${var.project_name}-${var.environment}-alb"
  })
}

# Target Group Blue
resource "aws_lb_target_group" "blue" {
  name        = "${var.project_name}-${var.environment}-blue-tg"
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    enabled             = true
    healthy_threshold   = 2
    unhealthy_threshold = 3
    timeout             = 30
    interval            = 60
    path                = "/actuator/health"
    matcher             = "200,302"
    protocol            = "HTTP"
    port                = "traffic-port"
  }

  tags = merge(var.tags, {
    Name = "${var.project_name}-${var.environment}-blue-tg"
  })
}

# Target Group Green
resource "aws_lb_target_group" "green" {
  name        = "${var.project_name}-${var.environment}-green-tg"
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    enabled             = true
    healthy_threshold   = 2
    unhealthy_threshold = 3
    timeout             = 30
    interval            = 60
    path                = "/actuator/health"
    matcher             = "200,302"
    protocol            = "HTTP"
    port                = "traffic-port"
  }

  tags = merge(var.tags, {
    Name = "${var.project_name}-${var.environment}-green-tg"
  })
}

# ALB Listener - Blue/Green 배포용으로 수정
resource "aws_lb_listener" "main" {
  load_balancer_arn = aws_lb.main.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "forward"
    
    forward {
      target_group {
        arn    = aws_lb_target_group.blue.arn
        weight = 100
      }
      
      target_group {
        arn    = aws_lb_target_group.green.arn
        weight = 0
      }
      
      stickiness {
        enabled  = false
        duration = 1
      }
    }
  }

  tags = merge(var.tags, {
    Name = "${var.project_name}-${var.environment}-listener"
  })

  lifecycle {
    ignore_changes = [default_action]
  }
}

# Test Listener for Blue/Green deployment
resource "aws_lb_listener" "test" {
  load_balancer_arn = aws_lb.main.arn
  port              = "8080"
  protocol          = "HTTP"

  default_action {
    type = "forward"
    
    forward {
      target_group {
        arn    = aws_lb_target_group.green.arn
        weight = 100
      }
      
      stickiness {
        enabled  = false
        duration = 1
      }
    }
  }

  tags = merge(var.tags, {
    Name = "${var.project_name}-${var.environment}-test-listener"
  })

  lifecycle {
    ignore_changes = [default_action]
  }
}