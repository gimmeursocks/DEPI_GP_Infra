resource "aws_docdb_subnet_group" "this" {
  name       = "${var.db_name}-subnet-group"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "${var.db_name}-subnet-group"
  }
}

resource "aws_docdb_cluster" "this" {
  cluster_identifier     = "${var.db_name}-cluster"
  engine                 = "docdb"
  master_username        = var.db_username
  master_password        = var.db_password
  db_subnet_group_name   = aws_docdb_subnet_group.this.name
  vpc_security_group_ids = var.vpc_security_group_ids
  skip_final_snapshot    = true # Set to false for production environments

  tags = {
    Name = "${var.db_name}-cluster"
  }
}

resource "aws_docdb_cluster_instance" "this" {
  count              = var.instance_count
  identifier         = "${var.db_name}-instance-${count.index}"
  cluster_identifier = aws_docdb_cluster.this.id
  instance_class     = var.instance_class

  tags = {
    Name = "${var.db_name}-instance-${count.index}"
  }
}