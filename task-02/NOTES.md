# Task 2 — Remote State & Locking

## Overview

- We have added `backend.tf` file to store the terraform state remotely on AWS S3 bucket and we have also enabled the DynamoDB state locking.
- S3 native state locking is also avaialble from Terraform's v1.11.x version onwards. And that can be enabled by setting the `use_lockfile` argument to `true`.
- **note** : Other terraform config files from task-01 are not placed here for brevity. We just need to copy paste backend.tf from here to task-01 in ordr to enable remote backend and state locking features.

## What Happens Today (With Current Local State)

- By default terraform stores the state locally (without configuring a backend) in a plaintext file called `terraform.tfstate` within the working directory.
- If two people run `terraform apply` at the same time using local state, Terraform has no way to block the duplicate execution.  
- Both engineers will blindly read their own local state files and there will be multiple issues such as duplicate resources, errors such as resource already exists, overwrite the other's changes mid-execution, causing deployment failures and resource desynchronization etc
- And also if we store the statefile on git repo for cross collaboration then we are exposing the sensitive data, raising merge conflicts difficult to solve etc.

## How the Remote Backend Change Prevents This

- Keeping the statefile on remote backend such as S3 Bucket with DynamoDB locking completely eliminates the risks seen above.
- With state locking enabled, Terraform writes a unique lock ID entry into the DynamoDB table with details such as lock id, who locked it etc.  
- If a second engineer tries to run an apply at the exact same time, Terraform checks DynamoDB, sees the active lock, and immediately terminates the second run with a `State Locked` error.  
Once the apply operation is completed, the statefile gets updated on the S3 Bucket with latest state info and then it releases the DynamoDB lock. 

**Other Benifits of remote state with locking enabled**
- only one person can modify the infra at a time
- tfstate may have some sensitive data and it's now secured on S3 bucket instead of pushing it to Git Repo which would expose the sensitive data.
- S3 has versioning feature which means, if something goes wrong then we have a way to restore previous statefile.