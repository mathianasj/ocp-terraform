resource "aws_security_group" "ec2" {
    name = "${chomp(data.remote_file.infra_name.content)}-ec2"
    vpc_id = aws_vpc.private.id

    depends_on = [ null_resource.provision_bastion ]
}

resource "aws_vpc_security_group_ingress_rule" "master-ec2" {
  security_group_id = aws_security_group.ec2.id
  referenced_security_group_id = aws_security_group.master.id

  from_port   = 443
  ip_protocol = "tcp"
  to_port     = 443
}

resource "aws_vpc_security_group_ingress_rule" "worker-ec2" {
  security_group_id = aws_security_group.ec2.id
  referenced_security_group_id = aws_security_group.worker.id

  from_port   = 443
  ip_protocol = "tcp"
  to_port     = 443
}

resource "aws_security_group" "bootstrap" {
    name = "${chomp(data.remote_file.infra_name.content)}-bootstrap"
    vpc_id = aws_vpc.private.id

    ingress {
        from_port = 22
        to_port = 22
        cidr_blocks = ["0.0.0.0/0"]
        protocol = "tcp"
    }

    ingress {
        from_port = 19531
        to_port = 19531
        cidr_blocks = ["0.0.0.0/0"]
        protocol = "tcp"
    }
}

resource "aws_security_group" "master" {
    name = "${chomp(data.remote_file.infra_name.content)}-master"
    vpc_id = aws_vpc.private.id

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    # ingress {
    #     from_port = 0
    #     to_port = 0
    #     protocol = "icmp"
    #     cidr_blocks = [aws_vpc.private.cidr_block, aws_vpc.public.cidr_block]
    # }

}

resource "aws_vpc_security_group_ingress_rule" "master_mc" {
  security_group_id = aws_security_group.master.id
  cidr_ipv4 = aws_vpc.private.cidr_block
  from_port = 22623
  to_port = 22623
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "master_api_public" {
  security_group_id = aws_security_group.master.id
  cidr_ipv4 = aws_vpc.public.cidr_block
  from_port = 6443
  to_port = 6443
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "master_api_private" {
  security_group_id = aws_security_group.master.id
  cidr_ipv4 = aws_vpc.private.cidr_block
  from_port = 6443
  to_port = 6443
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "master_ssh_public" {
  security_group_id = aws_security_group.master.id
  cidr_ipv4 = aws_vpc.public.cidr_block
  from_port = 22
  to_port = 22
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "master_ssh" {
  security_group_id = aws_security_group.master.id
  cidr_ipv4 = aws_vpc.private.cidr_block
  from_port = 22
  to_port = 22
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "master_etcd" {
  security_group_id = aws_security_group.master.id
  referenced_security_group_id = aws_security_group.master.id

  from_port   = 2379
  ip_protocol = "tcp"
  to_port     = 2380
}

resource "aws_vpc_security_group_ingress_rule" "master_vxlan" {
  security_group_id = aws_security_group.master.id
  referenced_security_group_id = aws_security_group.master.id

  from_port   = 4789
  ip_protocol = "udp"
  to_port     = 4789
}

resource "aws_vpc_security_group_ingress_rule" "master_worker_vxlan" {
  security_group_id = aws_security_group.master.id
  referenced_security_group_id = aws_security_group.worker.id

  from_port   = 4789
  ip_protocol = "udp"
  to_port     = 4789
}

resource "aws_vpc_security_group_ingress_rule" "master_geneve" {
  security_group_id = aws_security_group.master.id
  referenced_security_group_id = aws_security_group.master.id

  from_port   = 6081
  ip_protocol = "udp"
  to_port     = 6081
}

resource "aws_vpc_security_group_ingress_rule" "master_worker_geneve" {
  security_group_id = aws_security_group.master.id
  referenced_security_group_id = aws_security_group.worker.id

  from_port   = 6081
  ip_protocol = "udp"
  to_port     = 6081
}

resource "aws_vpc_security_group_ingress_rule" "master_ipsecike" {
  security_group_id = aws_security_group.master.id
  referenced_security_group_id = aws_security_group.master.id

  from_port   = 500
  ip_protocol = "udp"
  to_port     = 500
}

resource "aws_vpc_security_group_ingress_rule" "master_ipsecnat" {
  security_group_id = aws_security_group.master.id
  referenced_security_group_id = aws_security_group.master.id

  from_port   = 4500
  ip_protocol = "udp"
  to_port     = 4500
}

resource "aws_vpc_security_group_ingress_rule" "master_ipsecesp" {
  security_group_id = aws_security_group.master.id
  referenced_security_group_id = aws_security_group.master.id

  ip_protocol = "50"
}

resource "aws_vpc_security_group_ingress_rule" "master_worker_ipsecike" {
  security_group_id = aws_security_group.master.id
  referenced_security_group_id = aws_security_group.worker.id

  from_port   = 500
  ip_protocol = "udp"
  to_port     = 500
}

resource "aws_vpc_security_group_ingress_rule" "master_worker_ipsecnat" {
  security_group_id = aws_security_group.master.id
  referenced_security_group_id = aws_security_group.worker.id

  from_port   = 4500
  ip_protocol = "udp"
  to_port     = 4500
}

resource "aws_vpc_security_group_ingress_rule" "master_worker_ipsecesp" {
  security_group_id = aws_security_group.master.id
  referenced_security_group_id = aws_security_group.worker.id

  ip_protocol = "50"
}

resource "aws_vpc_security_group_ingress_rule" "master_internal_tcp" {
  security_group_id = aws_security_group.master.id
  referenced_security_group_id = aws_security_group.master.id

  from_port   = 9000
  ip_protocol = "tcp"
  to_port     = 9999
}

resource "aws_vpc_security_group_ingress_rule" "master_worker_internal_tcp" {
  security_group_id = aws_security_group.master.id
  referenced_security_group_id = aws_security_group.worker.id

  from_port   = 9000
  ip_protocol = "tcp"
  to_port     = 9999
}

resource "aws_vpc_security_group_ingress_rule" "master_internal_udp" {
  security_group_id = aws_security_group.master.id
  referenced_security_group_id = aws_security_group.master.id

  from_port   = 9000
  ip_protocol = "udp"
  to_port     = 9999
}

resource "aws_vpc_security_group_ingress_rule" "master_worker_internal_udp" {
  security_group_id = aws_security_group.master.id
  referenced_security_group_id = aws_security_group.worker.id

  from_port   = 9000
  ip_protocol = "udp"
  to_port     = 9999
}

resource "aws_vpc_security_group_ingress_rule" "master_kube" {
  security_group_id = aws_security_group.master.id
  referenced_security_group_id = aws_security_group.master.id

  from_port   = 10250
  ip_protocol = "tcp"
  to_port     = 10259
}

resource "aws_vpc_security_group_ingress_rule" "master_worker_kube" {
  security_group_id = aws_security_group.master.id
  referenced_security_group_id = aws_security_group.worker.id

  from_port   = 10250
  ip_protocol = "tcp"
  to_port     = 10259
}

resource "aws_vpc_security_group_ingress_rule" "master_ingress_ingress" {
  security_group_id = aws_security_group.master.id
  referenced_security_group_id = aws_security_group.master.id

  from_port   = 30000
  ip_protocol = "tcp"
  to_port     = 32767
}

resource "aws_vpc_security_group_ingress_rule" "master_worker_ingress_ingress" {
  security_group_id = aws_security_group.master.id
  referenced_security_group_id = aws_security_group.worker.id

  from_port   = 30000
  ip_protocol = "tcp"
  to_port     = 32767
}

resource "aws_vpc_security_group_ingress_rule" "master_ingress_ingress_udp" {
  security_group_id = aws_security_group.master.id
  referenced_security_group_id = aws_security_group.master.id

  from_port   = 30000
  ip_protocol = "udp"
  to_port     = 32767
}

resource "aws_vpc_security_group_ingress_rule" "master_worker_ingress_ingress_udp" {
  security_group_id = aws_security_group.master.id
  referenced_security_group_id = aws_security_group.worker.id

  from_port   = 30000
  ip_protocol = "udp"
  to_port     = 32767
}



resource "aws_security_group" "worker" {
    name = "${chomp(data.remote_file.infra_name.content)}-worker"
    vpc_id = aws_vpc.private.id

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    # ingress {
    #     from_port = 0
    #     to_port = 0
    #     protocol = "icmp"
    #     cidr_blocks = [aws_vpc.private.cidr_block]
    # }

    depends_on = [ null_resource.provision_bastion ]
}

resource "aws_vpc_security_group_ingress_rule" "worker_ssh_public" {
  security_group_id = aws_security_group.worker.id
  cidr_ipv4 = aws_vpc.public.cidr_block
  from_port = 22
  to_port = 22
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "worker_ssh_private" {
  security_group_id = aws_security_group.worker.id
  cidr_ipv4 = aws_vpc.private.cidr_block
  from_port = 22
  to_port = 22
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "worker_ingress_vxlan" {
  security_group_id = aws_security_group.worker.id
  referenced_security_group_id = aws_security_group.worker.id

  from_port   = 4789
  ip_protocol = "udp"
  to_port     = 4789
}

resource "aws_vpc_security_group_ingress_rule" "worker_ingress_master_vxlan" {
  security_group_id = aws_security_group.worker.id
  referenced_security_group_id = aws_security_group.master.id

  from_port   = 4789
  ip_protocol = "udp"
  to_port     = 4789
}

resource "aws_vpc_security_group_ingress_rule" "worker_ingress_geneve" {
  security_group_id = aws_security_group.worker.id
  referenced_security_group_id = aws_security_group.worker.id

  from_port   = 6081
  ip_protocol = "udp"
  to_port     = 6081
}

resource "aws_vpc_security_group_ingress_rule" "worker_ingress_master_geneve" {
  security_group_id = aws_security_group.worker.id
  referenced_security_group_id = aws_security_group.master.id

  from_port   = 6081
  ip_protocol = "udp"
  to_port     = 6081
}

resource "aws_vpc_security_group_ingress_rule" "worker_ipsecike" {
  security_group_id = aws_security_group.worker.id
  referenced_security_group_id = aws_security_group.worker.id

  from_port   = 500
  ip_protocol = "udp"
  to_port     = 500
}

resource "aws_vpc_security_group_ingress_rule" "worker_ipsecnat" {
  security_group_id = aws_security_group.worker.id
  referenced_security_group_id = aws_security_group.worker.id

  from_port   = 4500
  ip_protocol = "udp"
  to_port     = 4500
}

resource "aws_vpc_security_group_ingress_rule" "worker_ipsecesp" {
  security_group_id = aws_security_group.worker.id
  referenced_security_group_id = aws_security_group.worker.id

  ip_protocol = "50"
}

resource "aws_vpc_security_group_ingress_rule" "worker_master_ipsecike" {
  security_group_id = aws_security_group.worker.id
  referenced_security_group_id = aws_security_group.master.id

  from_port   = 500
  ip_protocol = "udp"
  to_port     = 500
}

resource "aws_vpc_security_group_ingress_rule" "worker_master_ipsecnat" {
  security_group_id = aws_security_group.worker.id
  referenced_security_group_id = aws_security_group.master.id

  from_port   = 4500
  ip_protocol = "udp"
  to_port     = 4500
}

resource "aws_vpc_security_group_ingress_rule" "worker_master_ipsecesp" {
  security_group_id = aws_security_group.worker.id
  referenced_security_group_id = aws_security_group.master.id

  ip_protocol = "50"
}

resource "aws_vpc_security_group_ingress_rule" "worker_internal" {
  security_group_id = aws_security_group.worker.id
  referenced_security_group_id = aws_security_group.worker.id

  from_port   = 9000
  ip_protocol = "tcp"
  to_port     = 9999
}

resource "aws_vpc_security_group_ingress_rule" "worker_master_internal" {
  security_group_id = aws_security_group.worker.id
  referenced_security_group_id = aws_security_group.master.id

  from_port   = 9000
  ip_protocol = "tcp"
  to_port     = 9999
}

resource "aws_vpc_security_group_ingress_rule" "worker_internal_udp" {
  security_group_id = aws_security_group.worker.id
  referenced_security_group_id = aws_security_group.worker.id

  from_port   = 9000
  ip_protocol = "udp"
  to_port     = 9999
}

resource "aws_vpc_security_group_ingress_rule" "worker_master_internal_udp" {
  security_group_id = aws_security_group.worker.id
  referenced_security_group_id = aws_security_group.master.id

  from_port   = 9000
  ip_protocol = "udp"
  to_port     = 9999
}

resource "aws_vpc_security_group_ingress_rule" "worker_kube" {
  security_group_id = aws_security_group.worker.id
  referenced_security_group_id = aws_security_group.worker.id

  from_port   = 10250
  ip_protocol = "tcp"
  to_port     = 10250
}

resource "aws_vpc_security_group_ingress_rule" "worker_master_kube" {
  security_group_id = aws_security_group.worker.id
  referenced_security_group_id = aws_security_group.master.id

  from_port   = 10250
  ip_protocol = "tcp"
  to_port     = 10250
}

resource "aws_vpc_security_group_ingress_rule" "worker_ingress_service" {
  security_group_id = aws_security_group.worker.id
  referenced_security_group_id = aws_security_group.worker.id

  from_port   = 30000
  ip_protocol = "tcp"
  to_port     = 32767
}

resource "aws_vpc_security_group_ingress_rule" "worker_master_ingress_service" {
  security_group_id = aws_security_group.worker.id
  referenced_security_group_id = aws_security_group.master.id

  from_port   = 30000
  ip_protocol = "tcp"
  to_port     = 32767
}

resource "aws_vpc_security_group_ingress_rule" "worker_ingress_service_udp" {
  security_group_id = aws_security_group.worker.id
  referenced_security_group_id = aws_security_group.worker.id

  from_port   = 30000
  ip_protocol = "udp"
  to_port     = 32767
}

resource "aws_vpc_security_group_ingress_rule" "worker_master_ingress_service_udp" {
  security_group_id = aws_security_group.worker.id
  referenced_security_group_id = aws_security_group.master.id

  from_port   = 30000
  ip_protocol = "udp"
  to_port     = 32767
}

