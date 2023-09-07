resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow incoming ssh"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "allow_ssh_within_vpc" {
  name        = "allow_ssh_within_vpc"
  description = "Allow incoming ssh within vpc"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.vpc_cidr}"]
  }
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["${var.vpc_cidr}"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_security_group" "hashi_nodes" {
  name        = "hashi_nodes"
  description = "Security Group for hashi servers"
  vpc_id      = module.vpc.vpc_id

  ### VAULT BEGIN
  # API, CLUSTER - TCP
  ingress {
    from_port   = 8200
    to_port     = 8201
    protocol    = "tcp"
    cidr_blocks = ["${var.vpc_cidr}"]
  }
  ### VAULT END

  ### CONSUL BEGIN
  # DNS server - TCP, UDP
  ingress {
    from_port   = 8600
    to_port     = 8600
    protocol    = "tcp"
    cidr_blocks = ["${var.vpc_cidr}"]
  }
  ingress {
    from_port   = 8600
    to_port     = 8600
    protocol    = "udp"
    cidr_blocks = ["${var.vpc_cidr}"]
  }

  # Allow internal egress 8300 -> 8600 TCP
  egress {
    from_port   = 8300
    to_port     = 8503
    protocol    = "tcp"
    cidr_blocks = ["${var.vpc_cidr}"]
  }
  egress {
    from_port   = 8300
    to_port     = 8600
    protocol    = "udp"
    cidr_blocks = ["${var.vpc_cidr}"]
  }

  # HTTP API
  ingress {
    from_port   = 8500
    to_port     = 8503
    protocol    = "tcp"
    cidr_blocks = ["${var.vpc_cidr}"]
  }

  # LAN Serf - TCP, UDP
  ingress {
    from_port   = 8301
    to_port     = 8302
    protocol    = "tcp"
    cidr_blocks = ["${var.vpc_cidr}"]
  }
  ingress {
    from_port   = 8301
    to_port     = 8302
    protocol    = "udp"
    cidr_blocks = ["${var.vpc_cidr}"]
  }

  # Server RPC
  ingress {
    from_port   = 8300
    to_port     = 8300
    protocol    = "tcp"
    cidr_blocks = ["${var.vpc_cidr}"]
  }
  ### CONSUL END

  ### NOMAD BEGIN
  # Allow incoming HTTP
  ingress {
    from_port   = 4646
    to_port     = 4646
    protocol    = "tcp"
    cidr_blocks = ["${var.vpc_cidr}"]
  }
  # Allow incoming RPC
  ingress {
    from_port   = 4647
    to_port     = 4647
    protocol    = "tcp"
    cidr_blocks = ["${var.vpc_cidr}"]
  }
  # Allow incoming SERF TCP, UDP
  ingress {
    from_port   = 4648
    to_port     = 4648
    protocol    = "tcp"
    cidr_blocks = ["${var.vpc_cidr}"]
  }
  ingress {
    from_port   = 4648
    to_port     = 4648
    protocol    = "udp"
    cidr_blocks = ["${var.vpc_cidr}"]
  }
  ### NOMAD END
}
