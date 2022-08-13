resource "google_container_cluster" "primary" {
  name     = "my-kube-cluster"
  location = "us-central1-c"
  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 2
}

data "google_container_cluster" "primary" {
  project = "mykubeproject-358518"
  name     = "my-kube-cluster"
  location = "us-central1-c"
}
resource "google_container_node_pool" "primary_preemptible_nodes" {
  name       = "my-node-pool"
  location   = "us-central1-c"
  cluster    = google_container_cluster.primary.name
  node_count = 2

  node_config {
    ##preemptible  = true
    machine_type = "e2-medium"
    image_type = "COS_CONTAINERD"
    disk_size_gb = "60"
    disk_type = "pd-standard"
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    service_account =  "terraform-gcp-sa@mykubeproject-358518.iam.gserviceaccount.com"
    oauth_scopes    = [
      ##"https://www.googleapis.com/auth/cloud-platform",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/servicecontrol",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/trace.append"
    ]
  }
}

resource "null_resource" "get-credentials" {

 depends_on = [google_container_cluster.primary]
 
 provisioner "local-exec" {
   command = "gcloud container clusters get-credentials ${google_container_cluster.primary.name} --zone=${google_container_cluster.primary.location}"
 }
}