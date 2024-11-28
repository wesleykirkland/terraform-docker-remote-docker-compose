# Pretty up our values and split them out for reuse
locals {
  compose_file_short_split     = split("/", var.local_compose_file)
  compose_file_short_extension = local.compose_file_short_split[length(local.compose_file_short_split) - 1]
  compose_file_short           = split(".", local.compose_file_short_split[length(local.compose_file_short_split) - 1])[0]
  full_compose_path            = "${var.remote_compose_path}/${local.compose_file_short}/${local.compose_file_short_extension}"

  # Checksum validation for triggers, tracked in the state as it's stored in the null_resource triggers section
  compose_file_checksum = filemd5(local.compose_file_short_extension)
  env_file_checksum     = var.env_file != null ? filemd5(var.env_file) : null
}
