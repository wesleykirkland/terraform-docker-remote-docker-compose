#Use a local module call to decrypt .env file - MODULE NOT INCLUDED
# module "sample_decrypt" {
#   source = "./modules/sops-decrypt"

#   stack_name = "dashy"
#   env_file   = "./envs/dashy.env"
# }

#Call Module to call remote docker-compose
module "sample" {
  source = "/Path/to/module/terraform-docker-remote-docker-compose"

  docker_host          = "docker.example.com"
  ssh_user             = "username"
  local_compose_file   = "dashy.yaml"
  remote_compose_path  = "/mnt/disk1/appdata/docker"
  env_file             = module.sample_decrypt.env_path
  ssh_key              = "~/.ssh/jenkins"
  post_delete_env_file = false
  compose_action       = "delete"

  depends_on = [module.sample_decrypt]
}

#Use a local module call to decrypt .env file - MODULE NOT INCLUDED
# module "sample_delete" {
#   source = "./modules/sops-delete"

#   stack_name = "dashy"
#   env_file   = "./envs/dashy.env"

#   depends_on = [
#     module.test
#   ]
# }
