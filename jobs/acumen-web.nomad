job "acumen-web" {
  datacenters = ["dc1"]
  type        = "service"

  update {
    max_parallel     = 1
    min_healthy_time = "5s"
    healthy_deadline = "30s"
    progress_deadline = "1m"
    auto_revert      = true
  }

  group "web" {
    count = 3

    network {
      port "http" {
        to = 8080
      }
    }

    service {
      name = "acumen-web"
      port = "http"

      check {
        type     = "http"
        path     = "/health"
        interval = "3s"
        timeout  = "2s"
      }
    }

    task "server" {
      driver = "docker"

      config {
        image = "acumen-web:v2"
        ports = ["http"]
      }

      # Passing an invalid port forces health checks to fail
      env {
        APP_VERSION = "v3-broken"
        PORT        = "9999"
      }

      resources {
        cpu    = 100
        memory = 128
      }
    }
  }
}