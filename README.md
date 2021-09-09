# terraform-module-eks-service-account-with-oidc-iam-role
Terraform Module to create an EKS Kubernetes Service Account and Related AWS IAM Componenets

Allows for attaching any number of IAM policies and allowing any AWS Service via it's named prefix I.E ec2, rds, s3.

## tl;dr

```
terraform init
terraform apply
```

## Create IAM Role Componenets and Kubernetes Service Account

```
module "tinfoil_sa" {
    source                      = "github.com/tinfoilcipher/terraform-aws-eks-oidc-service-account"
    service_account_name        = "my-service-account"
    iam_policy_arns             = ["arn:aws:iam::aws:policy/AmazonS3FullAccess", "arn:aws:iam::123456789012:policy/custom-policy"]
    kubernetes_namespace        = "some-namespace"
    enabled_sts_services        = ["ec2", "rds", "s3"]
    openid_connect_provider_arn = module.eks_cluster.oidc_provider_arn
    openid_connect_provider_url = module.eks_cluster.oidc_provider_url
}
```

## Create IAM Role Componenets Only

```
module "tinfoil_sa" {
    source                      = "github.com/tinfoilcipher/terraform-aws-eks-oidc-service-account"
    service_account_name        = "tinfoil-sa"
    iam_policy_arns             = ["arn:aws:iam::668264849718:policy/tinfoil-limited-access"]
    kubernetes_namespace        = "tinfoil"
    enabled_sts_services        = ["ec2", "rds", "s3"]
    openid_connect_provider_arn = module.eks_cluster.oidc_provider_arn
    openid_connect_provider_url = module.eks_cluster.oidc_provider_url
    provision_k8s_sa            = false
}
```
