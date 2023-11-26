resource "helm_release" "akhq" {

  name       = "akhq"
  namespace  = "operations"
  repository = "https://akhq.io/"
  chart      = "akhq"

  create_namespace = true


  values = [
    file("${path.module}/values/akhq-values.yaml")
  ]

}