variable "bucket_name" { type = string }
variable "project_id" { type = string }
variable "location" { type = string }
variable "labels" { type = map(string) }
variable "kms_key_name" { type = string }
variable "enable_versioning" { type = bool default = true }
variable "archive_after_days" { type = number default = 365 }
