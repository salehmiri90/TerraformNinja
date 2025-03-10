variable "http_port" {
  description = "The HTTP port for the Nexus repository"
  type        = number
}

variable "projectname" {
  description = "The name of the Nginx configuration file for that specific project"
  type        = string
}

variable "bs_quota" {
  description = "quota size to set on blob store in MB"
  type        = number
}

