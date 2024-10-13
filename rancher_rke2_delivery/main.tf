#####################################
### Section for managing Rancher2 ###

provider "rancher2" {
  api_url   = var.rancher_api_url
  token_key = var.rancher_token_key
  insecure  = true
}

resource "rancher2_project" "project" {
  name        = var.project_name
  description = var.project_description
  cluster_id  = "c-d-3wrecfwbt6t9"

  resource_quota {
    project_limit {
      limits_cpu    = "60000m"
      limits_memory = "254659Mi"
    }
    namespace_default_limit {
      limits_cpu    = "20000m"
      limits_memory = "84886Mi"
    }
  }
}

resource "rancher2_namespace" "namespaces" {
  for_each    = toset(var.namespace_names)
  project_id  = rancher2_project.project.id
  name        = each.value
  description = "${each.value} namespace for ${var.project_name} project"
}
##########################
### Section for Gitlab ###

provider "gitlab" {
  base_url = "http://git.saleh.ir/"
  token    = "glpat-9e_yoQxsdpzsPzFa1e2UBfdFPgFA-"
  insecure = true
}

resource "gitlab_group" "group" {
  name        = "test_saleh"
  path        = "test_saleh"
  description = "This is an example group created by salehmiri"
}

resource "gitlab_project" "project" {
  name             = "test_saleh_project"
  namespace_id     = gitlab_group.group.id
  description      = "This is an example project created in the test_saleh Group."
  visibility_level = "private"
}

output "group_id" {
  value       = gitlab_group.group.id
  description = "ID of the created group"
}

data "gitlab_user" "user" {
  username = "s.miri"
}

resource "gitlab_group_membership" "member" {
  group_id     = gitlab_group.group.id
  user_id      = data.gitlab_user.user.id
  access_level = "maintainer"
  expires_at   = null
}

##################################
### Section for find free port ###
provider "null" {}

module "port_checker" {
  source     = "./modules/port_checker"
  start_port = var.start_port
  end_port   = var.end_port
  ssh_host   = var.ssh_host
}

data "local_file" "available_port" {
  filename   = "./modules/port_checker/available_port.txt"
  depends_on = [module.port_checker]
}

output "available_port" {
  value = data.local_file.available_port.content
}

###################################
### Section for Accessing Nexus ###
provider "nexus" {
  url      = "http://${var.ssh_host}:8091"
  username = var.nexus_user
  password = var.nexus_pass
}

module "nexus_repository" {
  source      = "./modules/nexus_repository"
  projectname = var.project_name
  http_port   = tonumber(trimspace(data.local_file.available_port.content))
  depends_on  = [module.port_checker]
}

module "nginx_template" {
  source      = "./modules/nginx_template"
  projectname = var.project_name
  listen_port = tonumber(trimspace(data.local_file.available_port.content) + 1000)
  proxy_port  = tonumber(trimspace(data.local_file.available_port.content))
  server_name = var.ssh_host
  depends_on  = [module.nexus_repository]
}

module "upload_nginx_config" {
  source      = "./modules/upload_nginx_config"
  sourcefile  = "/tmp/${var.project_name}.conf"
  destination = "/etc/nginx/conf.d/${var.project_name}.conf"
  projectname = var.project_name
  ssh_host    = var.ssh_host
  remote_user = var.remote_user
  remote_pass = var.remote_pass
  depends_on  = [module.nginx_template]
}

##################################