module "ap-west" {
  source = "./deployments"
  providers = {
    kubernetes = kubernetes.ap-west
    helm       = helm.ap-west
  }
  region = "ap-west"
}

module "ca-central" {
  source = "./deployments"
  providers = {
    kubernetes = kubernetes.ca-central
    helm       = helm.ca-central
  }
  region = "ca-central"
}


module "ap-southeast" {
  source = "./deployments"
  providers = {
    kubernetes = kubernetes.ap-southeast
    helm       = helm.ap-southeast
  }
  region = "ap-southeast"
}

module "us-central" {
  source = "./deployments"
  providers = {
    kubernetes = kubernetes.us-central
    helm       = helm.us-central
  }
  region = "us-central"
}

module "us-west" {
  source = "./deployments"
  providers = {
    kubernetes = kubernetes.us-west
    helm       = helm.us-west
  }
  region = "us-west"
}

module "us-east" {
  source = "./deployments"
  providers = {
    kubernetes = kubernetes.us-east
    helm       = helm.us-east
  }
  region = "us-east"
}

module "eu-west" {
  source = "./deployments"
  providers = {
    kubernetes = kubernetes.eu-west
    helm       = helm.eu-west
  }
  region = "eu-west"
}

module "ap-south" {
  source = "./deployments"
  providers = {
    kubernetes = kubernetes.ap-south
    helm       = helm.ap-south
  }
  region = "ap-south"
}

module "eu-central" {
  source = "./deployments"
  providers = {
    kubernetes = kubernetes.eu-central
    helm       = helm.eu-central
  }
  region = "eu-central"
}

module "ap-northeast" {
  source = "./deployments"
  providers = {
    kubernetes = kubernetes.ap-northeast
    helm       = helm.ap-northeast
  }
  region = "ap-northeast"
}

# TODO::Need to add all the kubeconfigs of all other clusters into one another

