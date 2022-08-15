provider "kubectl" {
  load_config_file       = false
  host                   = "https://${data.google_container_cluster.primary.endpoint}"
  ##token                  = "${data.google_container_cluster.primary.access_token}"
  cluster_ca_certificate = base64decode(data.google_container_cluster.primary.master_auth.0.cluster_ca_certificate)
}

data "kubectl_path_documents" "manifests" {
  pattern = "./app_module/*.yml"
}

/*data "kubectl_filename_list" "manifests" {
  pattern = "./app_module/*.yml"
}*/

resource "kubectl_manifest" "deploy_dev" {
  //count     = length(data.kubectl_filename_list.manifests.matches)
  //yaml_body = file(element(data.kubectl_filename_list.manifests.matches, count.index))
  count     = length(data.kubectl_path_documents.manifests.documents)
  yaml_body = element(data.kubectl_path_documents.manifests.documents, count.index)

}