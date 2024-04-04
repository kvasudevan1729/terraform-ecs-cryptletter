locals {
  redis_secret_arn = data.terraform_remote_state.cryptletter_ecs_secret.outputs.cryptletter_redis_secret_arn
}

resource "aws_cloudwatch_log_group" "cryptletter_ecs_log_group" {
  name = "cryptletter-ecs-cw-logs"

  tags = {
    Application = "cryptletter-ecs-logs"
  }
}

resource "aws_ecs_cluster" "cryptletter_ecs_cluster" {
  name = "cryptletter-ecs-cluster"
  tags = {
    Name = "cryptletter-ecs"
  }
}
# To reference other container within the same task definition, use localhost, see:
# https://docs.aws.amazon.com/AmazonECS/latest/developerguide/fargate-task-networking.html
resource "aws_ecs_task_definition" "cryptletter_ecs_task" {
  family                   = "cryptletter-redis-ecs"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  memory                   = "2048"
  cpu                      = "1024"
  execution_role_arn       = data.terraform_remote_state.cryptletter_ecs_iam.outputs.ecs_task_exec_role_arn
  task_role_arn            = data.terraform_remote_state.cryptletter_ecs_iam.outputs.ecs_task_exec_role_arn

  container_definitions = <<DEFINITION
[
  {
    "image": "972362607701.dkr.ecr.eu-west-1.amazonaws.com/cryptletter:latest",
    "cpu": 512,
    "memory": 1024,
    "name": "cryptletter",
    "networkMode": "awsvpc",
    "environment": [
     {
       "Name": "REDIS__ADDRESS",
       "Value": "localhost:6379"
     }
    ],
    "secrets": [
      {
        "name": "REDIS__PASSWORD",
        "valueFrom": "${local.redis_secret_arn}"
      }
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
         "awslogs-group": "${aws_cloudwatch_log_group.cryptletter_ecs_log_group.id}",
         "awslogs-region": "${var.cw_aws_region}",
         "awslogs-stream-prefix": "cryptletter-ecs"
      }
    },
    "portMappings": [{
       "containerPort": 8080,
       "hostPort": 8080
     }]
  },
  {
    "image": "public.ecr.aws/docker/library/redis:alpine3.19",
    "cpu": 512,
    "memory": 1024,
    "name": "cryptletter-redis",
    "networkMode": "awsvpc",
    "command": ["/bin/sh", "-c", "redis-server --requirepass $${REDIS_PASSWORD}"],
    "secrets": [
      {
        "name": "REDIS_PASSWORD",
        "valueFrom": "${local.redis_secret_arn}"
      }
    ],
    "healthCheck": {
      "command": ["CMD-SHELL", "echo 'AUTH $${REDIS_PASSWORD}' | redis-cli"],
      "retries": 3,
      "timeout": 3,
      "interval": 30
    },
    "logConfiguration": {
       "logDriver": "awslogs",
       "options": {
          "awslogs-group": "${aws_cloudwatch_log_group.cryptletter_ecs_log_group.id}",
          "awslogs-region": "${var.cw_aws_region}",
          "awslogs-stream-prefix": "cryptletter-ecs"
        }
    },
    "portMappings": [
      {
        "containerPort": 6379,
        "hostPort": 6379
      }
    ]
  }
]
DEFINITION

  tags = {
    Application = "cryptletter-ecs-tasks"
  }
}

resource "aws_security_group" "cryptletter_ecs_task_sg" {
  name   = "cryptletter-ecs-task-sg"
  vpc_id = data.aws_vpc.cryptletter_vpc.id

  ingress {
    from_port       = 8080
    protocol        = "tcp"
    to_port         = 8080
    security_groups = [aws_security_group.cryptletter_lb_ingress.id]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_ecs_service" "cryptletter_ecs_service" {
  name            = "cryptletter-ecs-service"
  cluster         = aws_ecs_cluster.cryptletter_ecs_cluster.id
  task_definition = aws_ecs_task_definition.cryptletter_ecs_task.id
  desired_count   = var.cryptletter_ecs_app_count
  launch_type     = "FARGATE"

  network_configuration {
    security_groups = [aws_security_group.cryptletter_ecs_task_sg.id]
    subnets         = data.aws_subnets.cryptletter_private_subnets.ids
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.cryptletter_tgt_group.arn
    container_name   = "cryptletter"
    container_port   = 8080
  }

  depends_on = [aws_lb_listener.cryptletter_lb_listener]

  tags = {
    Name = "cryptletter-ecs-service"
  }
}

resource "aws_route53_record" "cryptletter_ecs_svc_dns" {
  zone_id = data.aws_route53_zone.cryptletter_dns_zone.id
  name    = "cryptletter-ecs.${var.cryptletter_dns_zone}"
  type    = "CNAME"
  ttl     = "300"
  records = [aws_lb.cryptletter_lb.dns_name]
}