resource "aws_security_group" "cryptletter_lb_ingress" {
  name   = "cryptletter-lb-sg"
  vpc_id = data.aws_vpc.cryptletter_vpc.id

  ingress {
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = var.client_src_cidr_blocks
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb" "cryptletter_lb" {
  name            = "cryptletter-lb"
  internal        = false
  subnets         = data.aws_subnets.cryptletter_public_subnets.ids
  security_groups = [aws_security_group.cryptletter_lb_ingress.id]

  tags = {
    Application = "cryptletter-redis-ecs"
  }
}

resource "aws_lb_target_group" "cryptletter_tgt_group" {
  name        = "cryptletter-tgt-group"
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = data.aws_vpc.cryptletter_vpc.id
  target_type = "ip"
}

resource "aws_lb_listener" "cryptletter_lb_listener" {
  load_balancer_arn = aws_lb.cryptletter_lb.id
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = data.aws_acm_certificate.cryptletter_cert.arn

  default_action {
    target_group_arn = aws_lb_target_group.cryptletter_tgt_group.id
    type             = "forward"
  }
}