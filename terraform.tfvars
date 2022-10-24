/*
 * Initialized Terraform variables.
 */

hiring_manager_name = "brad"

# always change this
candidate_name = "test"

# always change this. You can just flatten it to one line or use the EOT for multi-line
candidate_public_key = ""
#candidate_public_key = <<-EOT
#multi
#line value
#EOT

# no need to change this. Just let the candidate know the username is ubuntu.
#candidate_public_key_username = "ubuntu"

# Change this if you want it in a different region than us-east1 (default)
gcp_region = "us-east1"
