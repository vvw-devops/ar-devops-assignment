# Task 3 — Multi-Account IAM & Cross-Account Access

## Questions

1. Would you actually give engine and ci IAM users with access keys in a real production setup, or would you do something different? Explain.
2. In roleC's trust policy, why does it matter whether you trust the whole Account A root vs. roleB's specific ARN?

---

## Answers

1. In production, I would avoid creating IAM users and long-lived access keys for `engine` and `ci`. For CI workloads, I would use workload identity federation (for example, GitHub Actions OIDC) to obtain short-lived credentials by assuming a narrowly scoped IAM role. For workloads running on AWS, I would use the relevant service role, such as an EC2 instance profile or ECS task role. For people, I would use IAM Identity Center or the organization’s federated identity provider. This removes the burden and risk of managing permanent keys. If we must use the IAM User credentials for leagcy systems then I would grant only permissions it needs, store its key securely, rotate it on regular interval, and monitor its use while working towards removing it.

2. Trusting Account A's root principal means Account B trusts the whole Account A and any principal from Account A if assumes `roleC` using `sts:AssumeRole` permission then it gets access to `roleC` which is not secure. Allowing just `roleB`'s  arn in the trust policy makes sure that only that role can assume `roleC` of the Account-B making the cross-account boundary secure. In either design, `roleC` should also grant only the required S3 bucket permissions.

## Additional Info

- S3 buckets support resource policy which means to allow cross account access to s3 buckets we can do that diretcly while making sure only necessary permissions are allowed to necessary cross account principals.