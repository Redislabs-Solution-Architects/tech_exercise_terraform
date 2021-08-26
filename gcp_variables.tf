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
 * Terraform variable declarations for GCP.
 */

variable "candidate_public_key" {
  type        = string
}

variable "candidate_public_key_username" {
  description = "username found in candidate's provided public key file, or override"
  default     = "ubuntu"
  type        = string
}
variable "candidate_name" {
  type        = string
}

variable "hiring_manager_name" {
  default = "mgr"
  type        = string
}

variable "gcp_project_id" {
  default = "central-beach-194106"
  type        = string
}

variable "gcp_region" {
  description = "Default to us-east1 region."
  default     = "us-east1"
  type        = string
}

variable "instance_count" {
  description = "number of instances to create"
  default = 2
}

variable "gcp_instance_type" {
  description = "Machine Type. Correlates to an network egress cap."
  default     = "n1-standard-4"
}

variable "gcp_disk_image" {
  description = "Boot disk for gcp_instance_type."
  default     = "projects/ubuntu-os-cloud/global/images/family/ubuntu-1804-lts"
}

variable "gcp_network_cidr" {
  default = "10.240.0.0/16"
}

variable "gcp_subnet1_cidr" {
  default = "10.240.0.0/20"
}
