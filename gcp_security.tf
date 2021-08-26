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
 * Terraform security (firewall) resources for GCP.
 */

# Allow ports for tech exercise only
resource "google_compute_firewall" "gcp-allow-ext" {
  name    = "${google_compute_network.gcp-network.name}-gcp-allow-ext"
  network = google_compute_network.gcp-network.name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports = ["22","53","8443","9443","10000-19999"]
  }

  source_ranges = [
    "0.0.0.0/0",
  ]
}



