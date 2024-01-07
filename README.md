# K8s - Terraform - Helm

This repository contains samples to deploy in k8s cluster using Terraform and Helm provider, please refer to [the official doc for Helm provider](https://registry.terraform.io/providers/hashicorp/helm/latest/docs)

## Prerequisites
* Having a working k8s cluster, you can setup one with [minikube](https://minikube.sigs.k8s.io/docs/)
* Install CLIs (Terraform, kubectl, Helm)

## Deploying

To run this example:
```shell
terraform init
```
```shell
terraform validate
```
```shell
terraform plan
```
```shell
terraform apply
```

## Helpers

* Convert yaml to HCL
```
echo 'yamldecode(file("example.yaml"))' | terraform console
```