provider "linode" {
  token = var.LINODE_TOKEN
}

resource "linode_lke_cluster" "central" {
  label       = "net-central"
  k8s_version = "1.23"
  region      = "us-central"
  tags        = ["net"]

  pool {
    type  = "g6-dedicated-2"
    count = 1
  }
}

resource "local_file" "kube_config_central" {
  filename = "./deployments/us-central.yaml"
  content  = base64decode(linode_lke_cluster.central.kubeconfig)
}

resource "linode_lke_cluster" "east" {
  label       = "net-east"
  k8s_version = "1.23"
  region      = "us-east"
  tags        = ["net"]

  pool {
    type  = "g6-dedicated-2"
    count = 1
  }
}

resource "local_file" "kube_config_east" {
  filename = "./deployments/us-east.yaml"
  content  = base64decode(linode_lke_cluster.east.kubeconfig)
}

resource "linode_lke_cluster" "west" {
  label       = "net-west"
  k8s_version = "1.23"
  region      = "us-west"
  tags        = ["net"]

  pool {
    type  = "g6-dedicated-2"
    count = 1
  }
}

resource "local_file" "kube_config_west" {
  filename = "./deployments/us-west.yaml"
  content  = base64decode(linode_lke_cluster.west.kubeconfig)
}

resource "linode_lke_cluster" "apnortheast" {
  label       = "net-ap-northeast"
  k8s_version = "1.23"
  region      = "ap-northeast"
  tags        = ["net"]

  pool {
    type  = "g6-dedicated-2"
    count = 1
  }
}

resource "local_file" "kube_config_apnortheast" {
  filename = "./deployments/ap-northeast.yaml"
  content  = base64decode(linode_lke_cluster.apnortheast.kubeconfig)
}

resource "linode_lke_cluster" "apsoutheast" {
  label       = "net-ap-southeast"
  k8s_version = "1.23"
  region      = "ap-southeast"
  tags        = ["net"]

  pool {
    type  = "g6-dedicated-2"
    count = 1
  }
}

resource "local_file" "kube_config_apsoutheast" {
  filename = "./deployments/ap-southeast.yaml"
  content  = base64decode(linode_lke_cluster.apsoutheast.kubeconfig)
}

resource "linode_lke_cluster" "apwest" {
  label       = "net-ap-west"
  k8s_version = "1.23"
  region      = "ap-west"
  tags        = ["net"]

  pool {
    type  = "g6-dedicated-2"
    count = 1
  }
}

resource "local_file" "kube_config_apwest" {
  filename = "./deployments/ap-west.yaml"
  content  = base64decode(linode_lke_cluster.apwest.kubeconfig)
}

resource "linode_lke_cluster" "apsouth" {
  label       = "net-ap-south"
  k8s_version = "1.23"
  region      = "ap-south"
  tags        = ["net"]

  pool {
    type  = "g6-dedicated-2"
    count = 1
  }
}

resource "local_file" "kube_config_apsouth" {
  filename = "./deployments/ap-south.yaml"
  content  = base64decode(linode_lke_cluster.apsouth.kubeconfig)
}

resource "linode_lke_cluster" "eucentral" {
  label       = "net-eu-central"
  k8s_version = "1.23"
  region      = "eu-central"
  tags        = ["net"]

  pool {
    type  = "g6-dedicated-2"
    count = 1
  }
}

resource "local_file" "kube_config_eucentral" {
  filename = "./deployments/eu-central.yaml"
  content  = base64decode(linode_lke_cluster.eucentral.kubeconfig)
}

resource "linode_lke_cluster" "euwest" {
  label       = "net-eu-west"
  k8s_version = "1.23"
  region      = "eu-west"
  tags        = ["net"]

  pool {
    type  = "g6-dedicated-2"
    count = 1
  }
}

resource "local_file" "kube_config_euwest" {
  filename = "./deployments/eu-west.yaml"
  content  = base64decode(linode_lke_cluster.euwest.kubeconfig)
}

resource "linode_lke_cluster" "cacentral" {
  label       = "net-ca-central"
  k8s_version = "1.23"
  region      = "ca-central"
  tags        = ["net"]

  pool {
    type  = "g6-dedicated-2"
    count = 1
  }
}

resource "local_file" "kube_config_cacentral" {
  filename = "./deployments/ca-central.yaml"
  content  = base64decode(linode_lke_cluster.cacentral.kubeconfig)
}
