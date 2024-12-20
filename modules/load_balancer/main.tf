data "aws_vpc" "default" {
  default = true
}

#Default VPC
data "aws_subnets" "default_vpc_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

#Create a Load balanacer
resource "aws_lb" "swat-grafana-alb" {
  name               = "Swat-Grafana-ALb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.security_group_id] 
  subnets            = data.aws_subnets.default_vpc_subnets.ids

  tags = var.tags
}

#Create Prometheus Target Group and attach
resource "aws_lb_target_group" "prometheus-tg" {
  name        = "prometheus-tg"
  port        = 9090
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id = data.aws_vpc.default.id
}

resource "aws_lb_target_group_attachment" "prometheus-attach" {
  target_group_arn = aws_lb_target_group.prometheus-tg.arn
  target_id        = var.target_id
  port             = 9090
}

#Create Node Target group and attach
resource "aws_lb_target_group" "node-tg" {
  name        = "node-tg"
  port        = 9100
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id = data.aws_vpc.default.id
}

resource "aws_lb_target_group_attachment" "node-attach" {
  target_group_arn = aws_lb_target_group.node-tg.arn
  target_id        = var.target_id
  port             = 9100
}

#Create grafana Target group and attach
resource "aws_lb_target_group" "grafana-tg" {
  name        = "grafana-tg"
  port        = 3000
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id = data.aws_vpc.default.id
}

resource "aws_lb_target_group_attachment" "grafana-attach" {
  target_group_arn = aws_lb_target_group.grafana-tg.arn
  target_id        = var.target_id
  port             = 3000
}

#Create Prometheus Listener
resource "aws_lb_listener" "prometheus" {
  load_balancer_arn = aws_lb.swat-grafana-alb.arn
  port              = "9090"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.prometheus-tg.arn
  }
}

#Create Node Listener
resource "aws_lb_listener" "node" {
  load_balancer_arn = aws_lb.swat-grafana-alb.arn
  port              = "9100"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.node-tg.arn
  }
}

#Create Grafana Listerner
resource "aws_lb_listener" "grafana" {
  load_balancer_arn = aws_lb.swat-grafana-alb.arn
  port              = "3000"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.grafana-tg.arn
  }
}

#Create a Default 80 port Listener
resource "aws_lb_listener" "Default80Listener" {
  load_balancer_arn = aws_lb.swat-grafana-alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

#Create a Default 443 port listener
resource "aws_lb_listener" "Default443Listener" {
  load_balancer_arn = aws_lb.swat-grafana-alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.cert

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.grafana-tg.arn
  }
}

#Create a rule to identify host and forward to that target group
resource "aws_lb_listener_rule" "grafana_rule" {
  listener_arn = aws_lb_listener.Default443Listener.arn
  priority     = 1

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.grafana-tg.arn
  }

  condition {
    host_header {
      values = [var.grafana_host_header]
    }
  }
}

resource "aws_lb_listener_rule" "node_rule" {
  listener_arn = aws_lb_listener.Default443Listener.arn
  priority     = 2

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.node-tg.arn
  }

  condition {
    host_header {
      values = [var.node_host_header]
    }
  }
}

resource "aws_lb_listener_rule" "prometheus_rule" {
  listener_arn = aws_lb_listener.Default443Listener.arn
  priority     = 3

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.prometheus-tg.arn
  }

  condition {
    host_header {
      values = [var.prometheus_host_header]
    }
  }
}
