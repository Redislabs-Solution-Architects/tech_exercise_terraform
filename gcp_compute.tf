/*
 * Copyright 2017 Google Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/*
 * Terraform compute resources for GCP.
 * Acquire all zones and choose one randomly.
 */

data "google_compute_zones" "available" {
  region = var.gcp_region
}

resource "google_compute_address" "gcp-ip" {
  count = var.instance_count
  name   = "${var.hiring_manager_name}-sa-candidate-${var.candidate_name}-ip${count.index + 1}"
  region = var.gcp_region
}

resource "google_compute_instance" "gcp-vm" {
  count = var.instance_count
  name         = "${var.hiring_manager_name}-sa-candidate-${var.candidate_name}-vm${count.index + 1}"
  machine_type = var.gcp_instance_type
  zone         = data.google_compute_zones.available.names[0]
  labels = { "skip_deletion" = "yes"}

  metadata = {
    ssh-keys = "${var.candidate_public_key_username}:${var.candidate_public_key}"
    block-project-ssh-keys = true

  }

  boot_disk {
    initialize_params {
      image = var.gcp_disk_image
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.gcp-subnet1.name
    # network_ip = var.gcp_vm_address

    access_config {
      # Static IP
      nat_ip = google_compute_address.gcp-ip[count.index].address
    }
  }

}

# resource "google_compute_address" "gcp-ip2" {
#   name   = "${var.hiring_manager_name}-sa-candidate-${var.candidate_name}-ip2"
#   region = var.gcp_region
# }

# resource "google_compute_instance" "gcp-vm2" {
#   name         = "${var.hiring_manager_name}-sa-candidate-${var.candidate_name}-vm2"
#   machine_type = var.gcp_instance_type
#   zone         = data.google_compute_zones.available.names[0]

#   metadata = {
#     ssh-keys = "${var.candidate_public_key_username}:${var.candidate_public_key}"
#     block-project-ssh-keys = true
#   }

#   boot_disk {
#     initialize_params {
#       image = var.gcp_disk_image
#     }
#   }

#   network_interface {
#     subnetwork = google_compute_subnetwork.gcp-subnet1.name
# #    network_ip = var.gcp_vm_address

#     access_config {
#       # Static IP
#       nat_ip = google_compute_address.gcp-ip2.address
#     }
#   }

# }