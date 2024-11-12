variable "table_name" {
  default     = "resume-db"
  description = "name of the dynamodb table"
}

variable "hash_key" {
  default     = "id"
  description = "pk for dynamodb table"
}

variable "api_name" {
  default = "resume-api"
}