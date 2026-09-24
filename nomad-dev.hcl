datacenter = "dc1"
data_dir   = "C:\\tmp\\nomad"

client {
  enabled = true
}

plugin "docker" {
  config {
    endpoint = "npipe:////./pipe/docker_engine"
    allow_caps = ["ALL"]
    infra_image = ""
  }
}

consul {
  address = "127.0.0.1:8500"
}