provider "google" {
  project     = "mykubeproject-358518"
  region      = "us-west-2"
  credentials = "../../../docker/mykubeproject-terra-sa.json"
}

terraform {
  /*backend "gcs" {
    bucket      = "terra-backend-gcp-bucket"
    prefix      = "terraform/state"
    credentials = "../../../docker/mykubeproject-terra-sa.json"
  }*/
 backend "local"{
  path = "./terraform.tfstate"
  }

  required_providers {
  kubectl = {
    source  = "gavinbunney/kubectl"
    version = ">= 1.7.0"
  }
}

}