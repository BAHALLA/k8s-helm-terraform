resource "helm_release" "akhq" {

  name       = "akhq"
  namespace  = "operations"
  repository = "https://akhq.io/"
  chart      = "akhq"
  version    = var.software_versions["akhq"]

  create_namespace = true


  values = [
    file("${path.module}/values/akhq-values.yaml")
  ]

}

resource "helm_release" "strimzi" {

  name      = "strimzi"
  namespace = "strimzi"
  chart     = "https://github.com/strimzi/strimzi-kafka-operator/releases/download/0.39.0/strimzi-kafka-operator-helm-3-chart-0.39.0.tgz"

  create_namespace = true
}

resource "kubernetes_manifest" "kafka" {

  manifest = {
    "apiVersion" = "kafka.strimzi.io/v1beta2"
    "kind"       = "Kafka"
    "metadata" = {
      "name"      = "my-cluster"
      "namespace" = "strimzi"
    }
    "spec" = {
      "entityOperator" = {
        "topicOperator" = {}
        "userOperator"  = {}
      }
      "kafka" = {
        "config" = {
          "default.replication.factor"               = 1
          "inter.broker.protocol.version"            = "3.6"
          "min.insync.replicas"                      = 1
          "offsets.topic.replication.factor"         = 1
          "transaction.state.log.min.isr"            = 1
          "transaction.state.log.replication.factor" = 1
        }
        "listeners" = [
          {
            "name" = "plain"
            "port" = 9092
            "tls"  = false
            "type" = "internal"
          },
          {
            "name" = "tls"
            "port" = 9093
            "tls"  = true
            "type" = "internal"
          },
          {
            "name" = "external"
            "port" = 9094
            "tls"  = true
            "type" = "nodeport"
            "configuration" = {
              "bootstrap" = {
                "alternativeNames" = ["192.168.49.2"]
                "nodePort"         = 30663
              }
            }
          },
        ]
        "replicas" = 1
        "storage" = {
          "type" = "jbod"
          "volumes" = [
            {
              "deleteClaim" = false
              "id"          = 0
              "size"        = "10Gi"
              "type"        = "persistent-claim"
            },
          ]
        }
        "version" = "3.6.1"
      }
      "zookeeper" = {
        "replicas" = 1
        "storage" = {
          "deleteClaim" = false
          "size"        = "10Gi"
          "type"        = "persistent-claim"
        }
      }
    }

  }

  depends_on = [helm_release.strimzi]
}