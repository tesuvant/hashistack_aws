

# resource "aws_lb" "hashi_servers_lb" {
#   name               = "hashi-servers-lb"
#   internal           = true
#   load_balancer_type = "network"
#   subnets            = module.vpc.private_subnets
#   tags = {
#     Environment = "test"
#   }
# }

# resource "aws_lb_target_group" "hashi_servers_api" {
#   name        = "hashi-servers-api"
#   port        = 6443
#   protocol    = "TCP"
#   vpc_id      = module.vpc.vpc_id
#   target_type = "ip"

#   health_check {
#     port                = 6443
#     protocol            = "TCP"
#     interval            = 30
#     healthy_threshold   = 2
#     unhealthy_threshold = 2
#   }
# }

# resource "aws_lb_listener" "hashi_servers_lb_listener" {
#   load_balancer_arn = aws_lb.hashi_servers_lb.arn
#   port              = 6443
#   protocol          = "TCP"

#   default_action {
#     target_group_arn = aws_lb_target_group.hashi_servers_api.id
#     type             = "forward"
#   }
# }

# resource "aws_lb_target_group_attachment" "hashi_servers_attachment" {
#   count            = length(aws_instance.servers.*.id)
#   target_group_arn = aws_lb_target_group.hashi_servers_api.arn
#   target_id        = aws_instance.servers.*.private_ip[count.index]
# }
