variable "project_name" { type = string }
variable "project_id" { type = string }
variable "folder_id" { type = string }
variable "labels" { type = map(string) }
variable "enabled_apis" { type = list(string) }
variable "iam_members" {
  type = map(object({ role = string, member = string }))
  default = {}
}
