resource "kubernetes_manifest" "schema_registry" {
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
                  "value" = "my-cluster-kafka-bootstrap.strimzi:9092"
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