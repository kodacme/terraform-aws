# DB Subnet Group
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_subnet_group
resource "aws_db_subnet_group" "dev-db-subnet" {
  name       = "kodacdev-db-subnet"
  subnet_ids = var.db-subnet-ids

  tags = {
    Name = "kodacdev-db-subnet"
  }
}

# DB instance
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance
resource "aws_db_instance" "dev-db" {
  identifier           = "${var.db-prefix}-kodacdev-db"
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "postgres"
  engine_version       = var.postgres-version
  instance_class       = var.instance-class
  db_name              = var.database-name
  username             = var.username
  password             = var.password
  db_subnet_group_name = aws_db_subnet_group.dev-db-subnet.name
  skip_final_snapshot  = true

  tags = {
    Name = "kodacdev-db"
  }
}
