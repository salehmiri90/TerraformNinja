rancher_api_url     = "https://rancher.saleh.ir/v3"
rancher_token_key   = "kubeconfig-m-i3sxgwoz6h82fwdcx4bwkw98m8hr2"
rancher_ssl         = true
rancher_cluster_id  = "c-d-3wrecfwbt6t9"
project_name        = "salehmiri"
project_description = "Project for Saleh Miri"
project_quota_cpu   = "60000m"
project_quota_mem   = "254659Mi"
namespace_quota_cpu = "20000m"
namespace_quota_mem = "84886Mi"
namespace_names     = ["miri-dev", "miri-uat", "miri-prd"]
####
gitlab_url          = "http://git.saleh.ir"
gitlab_token        = "glpat-9e_yoQxsdpzsPzFa1e2UBfdFPgFA-"
gitlab_ssl          = true
gitlab_group_path   = "test_saleh"
gitlab_group_descpn = "This is an example group created by salehmiri"
gitlab_project_descpn = "This is an example project created in the test_saleh Group."
gitlab_visibility   = "private"
gitlab_members      = [ "salehmiri90", "saleh" ]
start_port          = 5000
end_port            = 6000
ssh_host            = "12.7.2.11"
ssh_host_port       = 8091
remote_user         = "root"
remote_pass         = "saleh@miri"
nexus_user          = "admin"
nexus_pass          = "saleh@miri"