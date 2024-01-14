
variable "software_versions" {

  description = "Use this veriable to specify to version of components deployed with this module"
  type        = map(string)
  default = {
    "cert-manager" = "v1.13.3"
    "akhq"         = "0.24.0"
  }

}