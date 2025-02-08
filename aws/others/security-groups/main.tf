resource "aws_security_group" "my_fargate_service_lb_security_group6_fbf16_f1" {
  description = "Automatically created Security Group for ELB connectecsprodMyFargateServiceLBF80271FE"
  # ingress {
  #     cidr_blocks = ["0.0.0.0/0"]
  #     description = "Allow from anyone on port 80"
  #     from_port = 80
  #     protocol = "tcp"
  #     to_port = 80
  # }
  # ingress {
  #     cidr_blocks = ["0.0.0.0/0"]
  #     description = "Allow from anyone on port 443"
  #     from_port = 443
  #     protocol = "tcp"
  #     to_port = 443
  # }
  vpc_id = var.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "fargate_service_security_group_inbound_http" {
  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "tcp"
  description = "Allow from anyone on port 80"
  from_port = 80
  security_group_id = aws_security_group.my_fargate_service_lb_security_group6_fbf16_f1.id
  to_port = 80
}

resource "aws_vpc_security_group_ingress_rule" "fargate_service_security_group_inbound_https" {
  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "tcp"
  description = "Allow from anyone on port 443"
  from_port = 443
  security_group_id = aws_security_group.my_fargate_service_lb_security_group6_fbf16_f1.id
  to_port = 443
}

resource "aws_vpc_security_group_egress_rule" "my_fargate_service_security_groupfromconnectecsprod_my_fargate_service_lb_security_group6_a3_fa81_a30001_af1_dc97" {
  ip_protocol = "tcp"
  description = "Load balancer to target"
  from_port = 3000
  referenced_security_group_id = aws_security_group.my_fargate_service_security_group7016792_a.id
  security_group_id = aws_security_group.my_fargate_service_lb_security_group6_fbf16_f1.id
  to_port = 3000
}


resource "aws_security_group" "my_fargate_service_security_group7016792_a" {
  description = "connect-ecs-prod/MyFargateService/Service/SecurityGroup"
  # egress {
  #   from_port   = 0
  #   to_port     = 0
  #   protocol    = "-1"
  #   cidr_blocks = ["0.0.0.0/0"]
  #   description = "Allow all outbound traffic by default"
  # }
  vpc_id = var.vpc_id
}

resource "aws_vpc_security_group_egress_rule" "fargate_service_lb_security_group_all_outbound_traffic" {
  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = -1
  description = "Allow all outbound traffic by default"
  security_group_id = aws_security_group.my_fargate_service_security_group7016792_a.id
}

resource "aws_vpc_security_group_ingress_rule" "fargate_service_lb_security_grouptoconnectecsprod_my_fargate_service_security_group" {
  referenced_security_group_id = aws_security_group.my_fargate_service_lb_security_group6_fbf16_f1.id
  ip_protocol = "tcp"
  description = "Load balancer to target"
  security_group_id = aws_security_group.my_fargate_service_security_group7016792_a.id
  from_port = 3000
  to_port = 3000
}

output "security_group_1_arn" {
  value = aws_security_group.my_fargate_service_lb_security_group6_fbf16_f1.arn
}

output "security_group_2_arn" {
  value = aws_security_group.my_fargate_service_security_group7016792_a.arn
}
