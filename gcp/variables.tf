variable "server_count" {
  type        = number
  description = "Number of server nodes to keep running in the region"
  default     = 3
}

variable "server_base_name" {
  type        = string
  description = "The base instance name for the cluster servers"
  default     = "hashicorp"
}

variable "server_base_image" {
  type        = string
  description = "The base image name for the cluster servers"
}

variable "server_region" {
  type        = string
  description = "The region to launch the cluster instance"
}

variable "server_zones" {
  type        = list(string)
  description = "Overide the zones inside the region to use"
  default     = null
}

variable "machine_type" {
  type        = string
  description = "Instance size for servers"
  default     = "n1-standard-1"
}

locals {
  all_zones = {
    asia-east1              = ["a", "b", "c"]
    asia-east2              = ["a", "b", "c"]
    asia-northeast1         = ["a", "b", "c"]
    asia-northeast2         = ["a", "b", "c"]
    asia-northeast3         = ["a", "b", "c"]
    asia-south1             = ["a", "b", "c"]
    asia-southeast1         = ["a", "b", "c"]
    australia-southeast1    = ["a", "b", "c"]
    europe-north1           = ["a", "b", "c"]
    europe-west1            = ["b", "c", "d"]
    europe-west2            = ["a", "b", "c"]
    europe-west3            = ["a", "b", "c"]
    europe-west4            = ["a", "b", "c"]
    europe-west6            = ["a", "b", "c"]
    northamerica-northeast1 = ["a", "b", "c"]
    southamerica-east1      = ["a", "b", "c"]
    us-central1             = ["a", "b", "c", "f"]
    us-east1                = ["b", "c", "d"]
    us-east4                = ["a", "b", "c"]
    us-west1                = ["a", "b", "c"]
    us-west2                = ["a", "b", "c"]
    us-west3                = ["a", "b", "c"]
  }
}
