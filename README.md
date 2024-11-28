<!-- BEGIN_TF_DOCS -->
# Terraform Docker Remote Docker Compose

GitHub: [wesleykirkland/terraform-docker-remote-docker-compose](https://github.com/wesleykirkland/terraform-docker-remote-docker-compose)

Designed and originally created to remotely execute docker-compose stacks on unraid via remote ssh. Portainer stack management became unusable and with MacVLAN stack management became impossible.

Depends upon docker-compose being in the path on the remote system.

```hcl
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
```

---

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.9.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | ~> 3.2 |

## Resources

| Name | Type |
|------|------|
| [null_resource.cleanup](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.decrypt_and_transfer](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.post_delete_env_file](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.remote_docker_compose](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_compose_action"></a> [compose\_action](#input\_compose\_action) | Docker compose action up/down/delete | `string` | `"up"` | no |
| <a name="input_docker_host"></a> [docker\_host](#input\_docker\_host) | FQDN of your docker host to ssh to | `string` | n/a | yes |
| <a name="input_env_file"></a> [env\_file](#input\_env\_file) | Unencrypted ENV file to pass to the docker compose stack | `string` | `""` | no |
| <a name="input_force_pull_image"></a> [force\_pull\_image](#input\_force\_pull\_image) | Docker compose force pull image | `bool` | `false` | no |
| <a name="input_local_compose_file"></a> [local\_compose\_file](#input\_local\_compose\_file) | Path to docker compose file on the local file system | `string` | n/a | yes |
| <a name="input_post_delete_env_file"></a> [post\_delete\_env\_file](#input\_post\_delete\_env\_file) | Delete the ENV file after stack execution, highly not recommended | `bool` | `false` | no |
| <a name="input_remote_compose_path"></a> [remote\_compose\_path](#input\_remote\_compose\_path) | Path to docker compose file on the remote file system. We will make a folder with the stack name to store the stack in. | `string` | n/a | yes |
| <a name="input_ssh_key"></a> [ssh\_key](#input\_ssh\_key) | Path to the SSH key | `string` | n/a | yes |
| <a name="input_ssh_user"></a> [ssh\_user](#input\_ssh\_user) | ssh user | `string` | n/a | yes |

## Outputs

No outputs.

---

### Before this is applied, you need to configure the git hook on your local machine
```bash
# Test your pre-commit hooks - This will force them to run on all files
pre-commit run --all-files

# Add your pre-commit hooks forever
pre-commit install
```

Note: Before reading, uncomment the code for the environment that you
wish to apply the code to. This goes for both the init-tfvars and apply-tfvars
folders.

Note, manual changes to the README will be overwritten when the documentation is updated. To update the documentation, run `terraform-docs -c .config/.terraform-docs.yml .`
<!-- END_TF_DOCS -->