data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default_vpc_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

resource "aws_lb" "swat-grafana-alb" {
  name               = "Swat-Grafana-ALb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.security_group_id] 
  subnets            = data.aws_subnets.default_vpc_subnets.ids

  tags = var.tags
}

resource "aws_lb_target_group" "prometheus-tg" {
  name        = "prometheus-tg"
  port        = 3000
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id = data.aws_vpc.default.id
}

resource "aws_lb_target_group_attachment" "prometheus-attach" {
  target_group_arn = aws_lb_target_group.prometheus-tg.arn
  target_id        = var.target_id
  port             = 3000
}

resource "aws_lb_target_group" "node-tg" {
  name        = "node-tg"
  port        = 9090
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id = data.aws_vpc.default.id
}

resource "aws_lb_target_group_attachment" "node-attach" {
  target_group_arn = aws_lb_target_group.node-tg.arn
  target_id        = var.target_id
  port             = 9090
}

resource "aws_lb_target_group" "grafana-tg" {
  name        = "grafana-tg"
  port        = 9100
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id = data.aws_vpc.default.id
}

resource "aws_lb_target_group_attachment" "grafana-attach" {
  target_group_arn = aws_lb_target_group.grafana-tg.arn
  target_id        = var.target_id
  port             = 9100
}

resource "aws_lb_listener" "prometheus" {
  load_balancer_arn = aws_lb.swat-grafana-alb.arn
  port              = "9090"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.prometheus-tg.arn
  }
}

resource "aws_lb_listener" "node" {
  load_balancer_arn = aws_lb.swat-grafana-alb.arn
  port              = "9100"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.node-tg.arn
  }
}

resource "aws_lb_listener" "grafana" {
  load_balancer_arn = aws_lb.swat-grafana-alb.arn
  port              = "3000"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.grafana-tg.arn
  }
}