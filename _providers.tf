provider "kubernetes" {
  alias       = "ap-northeast"
  config_path = "./deployments/ap-northeast.yaml"
}

provider "helm" {
  alias = "ap-northeast"
  kubernetes {
    config_path = "./deployments/ap-northeast.yaml"
  }
}

provider "kubernetes" {
  alias       = "ap-southeast"
  config_path = "./deployments/ap-southeast.yaml"
}

provider "helm" {
  alias = "ap-southeast"
  kubernetes {
    config_path = "./deployments/ap-southeast.yaml"
  }
}

provider "kubernetes" {
  alias       = "ap-south"
  config_path = "./deployments/ap-south.yaml"
}

provider "helm" {
  alias = "ap-south"
  kubernetes {
    config_path = "./deployments/ap-south.yaml"
  }
}

provider "kubernetes" {
  alias       = "ap-west"
  config_path = "./deployments/ap-west.yaml"
}

provider "helm" {
  alias = "ap-west"
  kubernetes {
    config_path = "./deployments/ap-west.yaml"
  }
}

provider "kubernetes" {
  alias       = "ca-central"
  config_path = "./deployments/ca-central.yaml"
}

provider "helm" {
  alias = "ca-central"
  kubernetes {
    config_path = "./deployments/ca-central.yaml"
  }
}

provider "kubernetes" {
  alias       = "eu-central"
  config_path = "./deployments/eu-central.yaml"
}

provider "helm" {
  alias = "eu-central"
  kubernetes {
    config_path = "./deployments/eu-central.yaml"
  }
}

provider "kubernetes" {
  alias       = "eu-west"
  config_path = "./deployments/eu-west.yaml"
}

provider "helm" {
  alias = "eu-west"
  kubernetes {
    config_path = "./deployments/eu-west.yaml"
  }
}

provider "kubernetes" {
  alias       = "us-central"
  config_path = "./deployments/us-central.yaml"
}

provider "helm" {
  alias = "us-central"
  kubernetes {
    config_path = "./deployments/us-central.yaml"
  }
}

provider "kubernetes" {
  alias       = "us-east"
  config_path = "./deployments/us-east.yaml"
}

provider "helm" {
  alias = "us-east"
  kubernetes {
    config_path = "./deployments/us-east.yaml"
  }
}

provider "kubernetes" {
  alias       = "us-west"
  config_path = "./deployments/us-west.yaml"
}

provider "helm" {
  alias = "us-west"
  kubernetes {
    config_path = "./deployments/us-west.yaml"
  }
}
