resource "kubernetes_manifest" "schema_registry_deploy" {
  depends_on = [helm_release.strimzi]
  manifest = {
    "apiVersion" = "apps/v1"
    "kind"       = "Deployment"
    "metadata" = {
      "labels" = {
        "app" = "schema-registry"
      }
      "name"      = "schema-registry"
      "namespace" = "strimzi"
    }
    "spec" = {
      "replicas" = 1
      "selector" = {
        "matchLabels" = {
          "app" = "schema-registry"
        }
      }
      "template" = {
        "metadata" = {
          "labels" = {
            "app" = "schema-registry"
          }
        }
        "spec" = {
          "containers" = [
            {
              "env" = [
                {
                  "name"  = "SCHEMA_REGISTRY_KAFKA_BROKERS"
                  "value" = "PLAINTEXT://my-cluster-kafka-bootstrap.strimzi:9092"
                },
                {
                  "name"  = "SCHEMA_REGISTRY_DEBUG"
                  "value" = "true"
                },
              ]
              "image" = "bitnami/schema-registry:7.4"
              "name"  = "schema-registry"
              "ports" = [
                {
                  "containerPort" = 8081
                },
              ]
            },
          ]
        }
      }
    }
  }
}

resource "kubernetes_manifest" "schema_registry_svc" {
  manifest = {
    "apiVersion" = "v1"
    "kind"       = "Service"
    "metadata" = {
      "name"      = "schema-registry"
      "namespace" = "strimzi"
    }
    "spec" = {
      "type" = "NodePort"
      "ports" = [
        {
          "port"       = 8081
          "protocol"   = "TCP"
          "targetPort" = 8081
          "nodePort"   = 30007
        },
      ]
      "selector" = {
        "app" = "schema-registry"
      }

    }
  }
}