resource "aws_security_group" "allow_delinea" {
  name        = "Delinea DC Communication"
  description = "Delinea DC Communication"
  vpc_id      = "vpc-25fb4742"

  ingress {
    description      = "Global Catalog"
    from_port        = 3268
    to_port          = 3268
    protocol         = "tcp"
    cidr_blocks      = [
                         "10.251.63.0/24",
                         "10.251.52.0/22",
                         "161.108.205.128/26",
                         "10.251.56.0/22",
                         "10.251.62.0/24",
                         "161.108.205.192/26",
                         "10.251.36.0/22",
                         "10.251.40.0/22",
                         "10.251.24.0/22",
                         "10.251.20.0/22",
                         "161.108.207.128/26",
                         "161.108.207.192/26",
                         "10.251.191.128/26",
                         "10.251.191.192/26",
                         "10.251.2.0/23",
                         "10.251.4.0/23",
                         "206.178.22.0/26",
                         "161.108.91.32/28",
                         "206.178.22.64/26",
                         "161.108.91.192/27",
                         "161.108.208.192/26",
                         "206.178.22.192/26",
                         "161.108.175.48/28",
                         "192.168.1.192/26",
                         "192.168.1.128/26",
                         "161.108.90.128/25",
                         "192.168.131.64/26",
                         "161.108.91.224/27",
                         "161.108.90.0/25",
                         "192.168.131.0/26",
                         "161.108.208.128/26",
                         "161.108.175.32/28",
                         "161.108.91.48/28",
                         "206.178.22.128/26"
                      ]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}

output "aws_security_group_id" {
  value = aws_security_group.allow_delinea.id
}