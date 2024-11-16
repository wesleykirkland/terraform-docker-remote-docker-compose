#How to fail on null_resource.remote_docker_compose (remote-exec): services.pihole.environment.[0]: unexpected type map[string]interface {}

# Decrypt and transfer the .env file
resource "null_resource" "decrypt_and_transfer" {
  count = var.compose_action == "up" || var.compose_action == "down" ? 1 : 0

  triggers = {
    compose_file_checksum = local.compose_file_checksum
    env_file_checksum     = local.env_file_checksum
    compose_action        = var.compose_action
    compose_file          = var.local_compose_file
  }

  provisioner "local-exec" {
    command = <<EOT
      # Make our docker compose directory, all related files will be stored here
      ssh -i ${var.ssh_key} ${var.ssh_user}@${var.docker_host} "mkdir -p ${var.remote_compose_path}/${local.compose_file_short}"

      # Transfer our yaml file
      scp -i ${var.ssh_key} ${var.local_compose_file} ${var.ssh_user}@${var.docker_host}:${var.remote_compose_path}/${local.compose_file_short}/

      # Transfer our env file if we specified one
      ${var.env_file != null ? "scp -i ${var.ssh_key} ${var.env_file} ${var.ssh_user}@${var.docker_host}:${var.remote_compose_path}/${local.compose_file_short}/.env" : ""}
    EOT
  }
}

# Null resource to run the script remotely
resource "null_resource" "remote_docker_compose" {
  count = var.compose_action == "up" || var.compose_action == "down" ? 1 : 0

  triggers = {
    compose_file_checksum = local.compose_file_checksum
    env_file_checksum     = local.env_file_checksum
    compose_action        = var.compose_action
    compose_file          = local.full_compose_path
  }

  # SSH provisioner to run the script on the Unraid server
  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      host        = var.docker_host
      user        = var.ssh_user
      private_key = file(var.ssh_key)
    }

    inline = [
      "docker-compose -f ${self.triggers.compose_file} ${var.env_file != null ? "--env-file ${var.remote_compose_path}/${local.compose_file_short}/.env" : ""} ${self.triggers.compose_action} ${var.compose_action == "up" ? "-d" : ""}",
    ]
  }

  depends_on = [
    null_resource.decrypt_and_transfer
  ]
}


resource "null_resource" "post_delete_env_file" {
  count = (var.compose_action == "up" || var.compose_action == "down") && var.post_delete_env_file == true ? 1 : 0

  triggers = {
    compose_file_checksum = local.compose_file_checksum
    env_file_checksum     = local.env_file_checksum
    compose_action        = var.compose_action
    compose_file          = local.full_compose_path
  }

  provisioner "local-exec" {
    command = <<EOT
      # Make our docker compose directory, all related files will be stored here
      ssh -i ${var.ssh_key} ${var.ssh_user}@${var.docker_host} "rm -f ${var.remote_compose_path}/${local.compose_file_short}/.env"
    EOT
  }

  depends_on = [
    null_resource.remote_docker_compose
  ]
}

# Cleanup
resource "null_resource" "cleanup" {
  count = var.compose_action == "delete" ? 1 : 0

  provisioner "local-exec" {
    command = <<EOT
      # Make our docker compose directory, all related files will be stored here
      ssh -i ${var.ssh_key} ${var.ssh_user}@${var.docker_host} "rm -rf ${var.remote_compose_path}/${local.compose_file_short}"
    EOT
  }
}

