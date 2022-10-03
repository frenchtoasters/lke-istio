resource "kubernetes_namespace" "tidb" {
  metadata {
    name = "tidb"
  }
}

resource "kubernetes_namespace" "istio-system" {
  metadata {
    name = "istio-system"
    labels = {
      "topology.istio.io/network" = "${var.region}"
    }
  }
}

resource "helm_release" "tidb-operator" {
  name       = "tidb-operator"
  repository = "https://charts.pingcap.org/"
  chart      = "tidb-operator"
  version    = "1.3.8"
  namespace  = "tidb"

  depends_on = [
    kubernetes_namespace.tidb
  ]
}

resource "helm_release" "istio-base" {
  name       = "istio-base"
  repository = "https://istio-release.storage.googleapis.com/charts"
  chart      = "base"
  version    = "1.15.1"
  namespace  = "istio-system"

  depends_on = [
    kubernetes_namespace.istio-system
  ]
}

resource "helm_release" "istiod" {
  name       = "istiod"
  repository = "https://istio-release.storage.googleapis.com/charts"
  chart      = "istiod"
  version    = "1.15.1"
  namespace  = "istio-system"

  depends_on = [
    kubernetes_namespace.istio-system
  ]
}

resource "helm_release" "istio-gateway" {
  name       = "istio-gateway"
  repository = "https://istio-release.storage.googleapis.com/charts"
  chart      = "gateway"
  version    = "1.15.1"
  namespace  = "istio-system"

  depends_on = [
    kubernetes_namespace.istio-system
  ]
}

data "local_sensitive_file" "kubeconfigs" {
  count    = length(var.regions)
  filename = "${path.module}/${var.regions[count.index]}.yaml"
}

resource "kubernetes_secret" "cluster-mesh-secret" {
  count = length(data.local_sensitive_file.kubeconfigs)
  metadata {
    annotations = {
      "networking.istio.io/cluster" = "${var.regions[count.index]}"
    }
    labels = {
      "istio/multiCluster" = "true"
    }
    name      = "istio-remote-secret-${var.regions[count.index]}"
    namespace = "istio-system"
  }
  data = {
    "${var.regions[count.index]}" = data.local_sensitive_file.kubeconfigs[count.index].content
  }
  depends_on = [
    helm_release.istio-base,
    helm_release.istiod,
    helm_release.istio-gateway
  ]
}

resource "kubernetes_manifest" "cluster-mesh-istio-config" {
  manifest = {
    "apiVersion" = "install.istio.io/v1alpha1"
    "kind"       = "IstioOperator"
    "metadata" = {
      "name"      = "cluster-mesh"
      "namespace" = "istio-system"
    }
    "spec" = {
      "values" = {
        "meshID"  = "mesh1"
        "network" = "${var.region}"
        "multiCluster" = {
          "clusterName" = "${var.region}-cluster"
        }
      }
    }
  }
  depends_on = [
    helm_release.istio-base,
    helm_release.istiod,
    helm_release.istio-gateway
  ]
}

resource "kubernetes_manifest" "east-west-expose" {
  manifest = {
    "apiVersion" = "networking.istio.io/v1alpha3"
    "kind"       = "Gateway"
    "metadata" = {
      "name"      = "cross-network-gateway"
      "namespace" = "istio-system"
    }
    "spec" = {
      "selector" = {
        "istio" = "eastwestgateway"
      }
      "servers" = [{
        "port" = {
          "number"   = "15443"
          "name"     = "tls"
          "protocol" = "TLS"
        }
        "tls" = {
          "mode" = "AUTO_PASSTHROUGH"
        }
        "hosts" = [
          "*.local"
        ]
      }]
    }
  }
  depends_on = [
    helm_release.istio-base,
    helm_release.istiod,
    helm_release.istio-gateway
  ]
}

resource "kubernetes_manifest" "east-west-config" {
  manifest = {
    "apiVersion" = "install.istio.io/v1alpha1"
    "kind"       = "IstioOperator"
    "metadata" = {
      "name"      = "eastwest"
      "namespace" = "istio-system"
    }
    "spec" = {
      "revision" = ""
      "profile"  = "empty"
      "components" = {
        "ingressGateways" = [{
          "name" = "istio-eastwestgateway"
          "label" = {
            "istio"                     = "eastwestgateway"
            "app"                       = "istio-eastwestgateway"
            "topology.istio.io/network" = "${var.region}"
          }
          "enabled" = "true"
          "k8s" = {
            "env" = [{
              # traffic through this gateway should be routed inside the network
              "name"  = "ISTIO_META_REQUESTED_NETWORK_VIEW"
              "value" = "${var.region}"
            }]
            "service" = {
              "ports" = [
                { "name"       = "status-port"
                  "port"       = "15021"
                  "targetPort" = "15021"
                },
                { "name"       = "tls"
                  "port"       = "15443"
                  "targetPort" = "15443"
                },
                { "name"       = "tls-istiod"
                  "port"       = "15012"
                  "targetPort" = "15012"
                },
                { "name"       = "tls-webhook"
                  "port"       = "15017"
                  "targetPort" = "15017"
                }
              ]
            }
          }
        }]
      }
      "values" = {
        "gateways" = {
          "istio-ingressgateway" = {
            "injectionTemplate" = "gateway"
          }
        }
        "global" = {
          "network" = "${var.region}"
        }
      }
    }
  }
  depends_on = [
    helm_release.istio-base,
    helm_release.istiod,
    helm_release.istio-gateway
  ]
}

resource "kubernetes_manifest" "weight-rules" {
  manifest = {
    "apiVersion" = "networking.istio.io/v1beta1"
    "kind"       = "DestinationRule"
    "metadata" = {
      "name"      = "helloworld",
      "namespace" = "sample"
    }
    "spec" = {
      "host" = "helloworld.sample.svc.cluster.local"
      "trafficPolicy" = {
        "loadBalancer" = {
          "localityLbSetting" = {
            "enabled" = "true"
            "distribute" = [
              {
                "from" = "region1/zone1/*"
                "to" = {
                  "region1/zone1/*" = "70"
                  "region1/zone2/*" = "20"
                  "region1/zone4/*" = "10"
                }
              }
            ]
          }
        }
      "outlierDetection" = {
        "consecutive5xxErrors" = "100"
        "interval"             = "1s"
        "baseEjectionTime"     = "1m"
      }
	  }
    }
  }
  depends_on = [
    helm_release.istio-base,
    helm_release.istiod,
    helm_release.istio-gateway
  ]
}
