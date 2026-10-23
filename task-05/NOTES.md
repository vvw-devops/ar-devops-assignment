# Task 5 — Find and Fix the Bug

Below is a Terraform snippet `given.tf` meant to let roleB (Account A) assume roleC(Account B). It's broken. Fix it and explain in NOTES.md, in your own words, exactly why it was failing.

---

## Answer

I have added `fixed.tf` with below changes.

1. The ARN `arn:aws:iam::000000000000:user/roleB` belongs to an user named as `roleB` however if it is IAM Role instead of IAM User then it's arn should be `arn:aws:iam::000000000000:role/roleB`. So have replaced `:user/roleB` with `:role/roleB`
2. All permissions are granted to all the buckets. This should never be the case. So have restricted all permissions to specific bucket named as `SINGLE_BUCKET` only. If we need to restrict the permissions along with buckets then we can write multiple statements with specific permissions to specific buckets.
