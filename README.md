# Motivation

This repository demonstrates how to set up an ecs service using `terraform`.
The ecs application sets up [cryptletter](https://github.com/Scribblerockerz/cryptletter)
message encryption service and the underlying redis service as ecs service.

The setup demonstrates:
- setup of ECS service with a simple UI connecting to Redis DB.
- setup of the IAM privileges required to run the ecs service.
- setup of KMS key and secrets in AWS Secret Manager and how they referenced
  in the task definition for containers.

Once the setup is applied, the UI should be accessible from your localhost.
The DNS URL depends on your entries in the [tfvars config](ecs/terraform.tfvars).

## Pre-requisites

Terraform needs to be run from within each directory in the order given
below. Export the environment variables `AWS_PROFILE` and `AWS_REGION`, and
set terraform bucket in the `backend.conf`. Initialise
(`terraform init --backend-config=backend.conf`) and then
apply (`terraform apply`).

### AWS VPC

If you have an existing VPC, and wish to use that, you can skip this step.
If you wish to create a VPC, then modify [tfvars](vpc/terraform.tfvars)
accordingly.

### AWS IAM

Create the IAM policy for the ecs service to assume task execution role.

### AWS KMS

Now create the KMS key for secret encryption. Relies on the IAM role created
for ecs tasks in the [iam](iam) section. The ecs iam profile is allowed to
decrypt the kms key stored in AWS KMS.

### AWS Secret

Now create a plain-text secret in AWS with name `/cryptletter-redis-password`
[secrets.tf](secrets/secrets.tf) (line 5) to store redis password.
Relies on the kms key created in the [kms](kms) section,
and the iam profile created for ecs in the [iam](iam) section.
The ecs iam profile is allowed to retrieve the secret stored in the
AWS Secrets Manager.

### AWC Certificate

If you wish to create the certificate via ACM, then run apply from [acm](acm)
directory.

### AWS ECS

To set up the ecs service, from within the [ecs](ecs) directory,
ensure `terraform.tfvars` file is correctly populated, and run
`terraform apply`. This part of the terraform manifests relies on an
existing DNS domain, and a corresponding ACM certificate with it.
For testing purposes, the DNS and cert part can be excluded and to
access the service just use the external DNS name of the LB. The LB
is internet facing [lb.tf](ecs/lb.tf) (line 22) but connects to the
ecs service running in private subnets [ecs-cluster.tf](ecs/ecs-cluster.tf) (line 133).