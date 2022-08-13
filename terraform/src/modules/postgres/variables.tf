variable "db-subnet-ids" {
  type = list(string)
}

variable "postgres-version" {
  type = string
}

variable "instance-class" {
  type = string
}

variable "db-prefix" {
  type = string
}

variable "database-name" {
  type = string
}

variable "username" {
  type = string
}

variable "password" {
  type = string
}
