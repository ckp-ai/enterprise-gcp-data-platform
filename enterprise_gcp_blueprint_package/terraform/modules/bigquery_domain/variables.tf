variable "dataset_id" { type = string }
variable "project_id" { type = string }
variable "location" { type = string }
variable "description" { type = string }
variable "labels" { type = map(string) }
variable "owner_group" { type = string }
variable "default_table_expiration_ms" { type = number default = null }
variable "tables" {
  type = map(object({ schema = list(object({ name=string, type=string, mode=string, description=optional(string) })) }))
  default = {}
}
