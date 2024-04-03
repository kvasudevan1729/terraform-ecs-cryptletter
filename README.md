# Motivation

This repository demonstrates how to set up an ecs service using `terraform`.
The ecs application sets up [cryptletter](https://github.com/Scribblerockerz/cryptletter)
and the redis services as ecs tasks run within an ecs service.

## Pre-requisites

Please run `terraform apply` within each directory in the order given below.

### AWS IAM

Create the IAM policy for the ecs service to assume task execution role.

### AWS KMS

Now create the KMS key for secret encryption. Relies on the IAM role created
for ecs tasks in the [iam](iam) section. The ecs iam profile is allowed to
decrypt the kms key stored in AWS KMS.

### AWS secret

Now create a secret in AWS with name `/cryptletter-redis` to store redis
password. Relies on the kms key created in the [kms](kms) section, and
the iam profile created for ecs in the [iam](iam) section. The ecs iam
profile is allowed to retrieve the secret stored in the AWS Secrets
Manager.


