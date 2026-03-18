resource "aws_vpc_peering_connection" "default" {
  count = var.Is_peering_required ? 1 : 0
  
  # Acceptor
  peer_vpc_id   = data.aws_vpc.default.id

  # Requester
  vpc_id        = aws_vpc.main.id 

  auto_accept = true

  accepter {
    allow_remote_vpc_dns_resolution = true
  }

  requester {
    allow_remote_vpc_dns_resolution = true
  }

  tags = merge(
        local.common_tags,
        {
            #roboshop-dev-default
            Name = "${var.project}-${var.environment}-default"
        }
  )
}