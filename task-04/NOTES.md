# Task 4 — Least-Privilege Policy Writing

Write a custom IAM policy (not a managed policy like PowerUserAccess) for the ci user from Task 3, scoped to only what a CI pipeline actually needs to do the following — nothing more:  

- Push a Docker image to a specific ECR repository.
- Deploy a new task definition to a specific ECS service.
- Read (not write) a specific S3 bucket used for build artifacts.  

Write the policy JSON and explain in NOTES.md what you deliberately left out and why.

---

## Answer

A `ci-policy.json` file has been added here with only necesary permissions.  

- ECR authorization is account-wide at the API level, so `ecr:GetAuthorizationToken` requires `Resource: "*"`. The actual image upload actions are restricted to one repository.
- ECS registration and inspection are restricted to one task-definition family. The service update and inspection actions are restricted to one ECS service.
- `iam:PassRole` is needed because the task definition refers to an execution role and, optionally, an application task role. It is limited to those named roles and to passing them to ECS tasks. Do not include roles the task definition does not use.
- S3 access is read-only: `ListBucket` is scoped to the bucket and `GetObject` to its objects. No object writes or deletes are allowed.
- The ECR repo should be already created, so have skipped the repo creation actions.
- S3 put and/or delete objects permissions are also skipped since the goal is to only get the objects from the s3 and not put/update something there.
- Since we are not deploying to any other services such as Lambda, have not added any permissions related to it.
