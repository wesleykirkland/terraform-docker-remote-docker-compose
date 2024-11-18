variable "docker_host" {
  description = "FQDN of your docker host to ssh to"
  type        = string
}

variable "ssh_user" {
  description = "ssh user"
  type        = string
}

variable "local_compose_file" {
  description = "Path to docker compose file on the local file system"
  type        = string
}

variable "remote_compose_path" {
  description = "Path to docker compose file on the remote file system. We will make a folder with the stack name to store the stack in."
  type        = string
}

variable "env_file" {
  description = "Unencrypted ENV file to pass to the docker compose stack"
  type        = string
  default     = null
}

variable "ssh_key" {
  description = "Path to the SSH key"
  type        = string
}

variable "post_delete_env_file" {
  description = "Delete the ENV file after stack execution, highly not recommended"
  type        = bool
  default     = false
}

variable "compose_action" {
  description = "Docker compose action up/down/delete"
  type        = string
  default     = "up"

  validation {
    condition     = can(regex("^(up|down|delete)$", var.compose_action))
    error_message = "Invalid action selected, only allowed actions are: 'up', 'down', 'delete'"
  }
}

variable "force_pull_image" {
  description = "Docker compose force pull image"
  type        = bool
  default     = false
}

