project = "bk8s-demo"

app "front" {
  path = "./front"
  labels = {
      "service" = "front",
      "env" = "dev"
  }
  url {
    auto_hostname = false
  }
  
  build {
    use "docker" {}
    registry {
      use "docker" {
        image = "gcr.io/hc-dcanadillas/bk8s-front"
        tag   = "latest"
      }
    }
  }

  deploy {
    use "kubernetes" {
      annotations = {
        "consul.hashicorp.com/connect-inject" = "true"
        "consul.hashicorp.com/connect-service" = "front"
        "consul.hashicorp.com/service-tags" = jsondecode(file("${path.project}/versions.json"))["front"]
        "consul.hashicorp.com/connect-service-upstreams" = "back:9090"
        "consul.hashicorp.com/connect-service-protocol" = "http"
      }
      service_port = "8080"
      service_account = "front"
      static_environment = {
        PORT = "8080"
        BACKEND_URL = "http://localhost:9090"
      }
      namespace = "apps"
    }
  }

  release {
    use "kubernetes" {
      port = "8080"
      namespace = "apps"
    }
  }
}

app "back" {
  path = "./back"
  labels = {
      "service" = "back",
      "env" = "dev"
  }
  url {
    auto_hostname = false
  }

  build {
    use "docker" {
      dockerfile = "${path.app}/Dockerfile"
    }
    registry {
      use "docker" {
        image = "gcr.io/hc-dcanadillas/bk8s-back"
        tag   = "latest"
      }
    }
  }

  deploy {
    use "kubernetes" {
      annotations = {
        "consul.hashicorp.com/connect-inject" = "true"
        "consul.hashicorp.com/connect-service" = "back"
        "consul.hashicorp.com/service-tags" = jsondecode(file("${path.project}/versions.json"))["back"]
        "consul.hashicorp.com/connect-service-protocol" = "http"
      }
      service_port = "8080"
      service_account = "back"
      static_environment = {
        PORT = "8080"
      }
      namespace = "apps"
    }
  }

  release {
    use "kubernetes" {
      port = "9090"
      namespace = "apps"
    }
  }
}
 
