resource "aws_docdb_subnet_group" "default" {
  name       = "default-subnet-group"
  subnet_ids = data.aws_subnets.default.ids
}

resource "aws_security_group" "docdb_sg" {
  name        = "docdb-sg"
  description = "Allow all inbound traffic for testing"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_docdb_cluster" "example" {
  cluster_identifier = "example-docdb-cluster"
  master_username    = "root"
  master_password    = "passw0rd"
  engine             = "docdb"
  skip_final_snapshot = true
  vpc_security_group_ids = [aws_security_group.docdb_sg.id]
  db_subnet_group_name   = aws_docdb_subnet_group.default.name
}

resource "aws_docdb_cluster_instance" "example_instance" {
  identifier         = "example-docdb-instance"
  cluster_identifier = aws_docdb_cluster.example.id
  instance_class     = "db.t3.medium"
}

output "docdb_connection_string" {
  description = "MongoDB connection string for the DocumentDB cluster"
  value = "mongodb://root:passw0rd@${aws_docdb_cluster.example.endpoint}:27017/?ssl=true&ssl_cert_reqs=CERT_NONE"
}
